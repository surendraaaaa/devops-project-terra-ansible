# Task
Integrate our existing, working `utils/argocd-deploy.yml` into our Azure DevOps master pipeline template so every application pipeline that already extends/uses the master template gets automated GitOps QA deployment.

# HARD CONSTRAINTS (do not violate)
1. DO NOT change any application pipeline YAML. Apps already call the master template and pass app-specific parameters. No new required parameters, no new top-level parameters in app pipelines.
2. All changes go only in the master template repo (master template + utils/*).
3. Existing behavior must not change: Build -> Deploy_OCP4 -> QA_Promotion (utils/qa-promotion.yml) -> Prod_Promotion (utils/prod-promotion.yml).
4. Prod_Promotion must depend on QA_Promotion ONLY, never on QA deploy stages.
5. Do NOT hardcode a pipeline ID. Use the predefined variable System.DefinitionId (env var SYSTEM_DEFINITIONID).
6. Do NOT use template parameters to switch modes in the re-run. Apps can't receive them. Use the Run Pipeline REST API fields `stagesToSkip` and `variables`.
7. QA deploy stages must run with `pool: server` (agentless). They must not occupy an agent.

# Context
- ~500 services, 40+ ADO projects. All build pipelines use the master template.
- The matrix (env list per service + GitOps file path to update per env) is resolved at RUNTIME by an existing matrix resolver. That logic already works. Reuse it, do not rewrite it.
- The deploy logic (branch/update file -> PR -> merge into GitOps repo) already works as a standalone POC. Reuse it inside the deploy stages.

# Desired flow
Run 1 (normal run of the app's build pipeline):
  Build -> Deploy_OCP4 -> QA_Promotion -> QA_Deploy_Trigger -> (Prod_Promotion depends on QA_Promotion only)
  QA_Deploy_Trigger: resolves envs + file paths from the matrix, then re-queues THE SAME pipeline
  via POST {org}/{project}/_apis/pipelines/{System.DefinitionId}/runs?api-version=7.1

Run 2 (the re-triggered run of the same pipeline, same commit):
  Only the QA deploy stages for the resolved envs run, in parallel, on pool: server.
  Build, Deploy_OCP4, QA_Promotion, QA_Deploy_Trigger, Prod_Promotion are all skipped.

# Implementation requirements
A. Stage names must be fixed and stable: Build, Deploy_OCP4, QA_Promotion, QA_Deploy_Trigger, Prod_Promotion, Deploy_<env>.

B. In utils/argocd-deploy.yml add:
   - parameter `envCatalog` (object) with a default superset list of all possible QA envs (e.g. qa1..qa8). Apps never pass it.
   - Stage `QA_Deploy_Trigger`, dependsOn: QA_Promotion, which runs the matrix resolver and the re-trigger script.
   - `${{ each env in parameters.envCatalog }}` generating stage `Deploy_${{ env }}` with:
       dependsOn: []
       condition: and(always(), eq(variables['DEPLOY_ONLY'],'true'), contains(format(',{0},', variables['TARGET_ENVS']), ',${{ env }},'))
       pool: server
     and your existing deploy tasks, using `$(DEPLOY_FILE_${{ env }})` for the GitOps file path and `$(IMAGE_TAG)` for the version.

C. Re-trigger script (replace the hardcoded pipeline ID):
   - org = SYSTEM_COLLECTIONURI, project = SYSTEM_TEAMPROJECT, pipeline id = SYSTEM_DEFINITIONID, auth = SYSTEM_ACCESSTOKEN
   - Request body:
       resources.repositories.self.refName = BUILD_SOURCEBRANCH
       resources.repositories.self.version = BUILD_SOURCEVERSION
       stagesToSkip = ["Build","Deploy_OCP4","QA_Promotion","QA_Deploy_Trigger","Prod_Promotion"]
       variables = DEPLOY_ONLY=true, TARGET_ENVS=<comma list>, IMAGE_TAG=<version>,
                   and one variable DEPLOY_FILE_<env>=<gitops file path> per resolved env
   - Fail loudly if the matrix returns an env that is not in envCatalog.
   - Exit with an error if the matrix resolves zero envs.

D. In master.yml call `- template: utils/argocd-deploy.yml` right after the QA promotion template and before prod promotion, while keeping Prod_Promotion's dependsOn: QA_Promotion.

E. Known gotchas to handle:
   - Runtime variables use $(VAR) or variables['VAR'], never inside ${{ }}.
   - Stage names cannot contain '-'. Use '_'.
   - Server jobs only support server tasks (e.g. InvokeRESTAPI), not script/python steps.
   - The Build Service identity needs 'Queue builds' permission on the pipelines.
   - "Limit variables that can be set at queue time" org setting may block undefined variables; mention how to handle it.

# Deliverables
1. Updated master.yml (only the diff needed).
2. Updated utils/argocd-deploy.yml (complete file).
3. Updated re-trigger script (complete file).
4. A short test plan using one service: how to check that a normal run skips all Deploy_<env> stages, and the re-run skips everything except the selected Deploy_<env> stages. Include how to use `previewRun` to validate the YAML.

If anything is ambiguous, list your assumptions at the top instead of changing the constraints above.
