import express from "express";
import mongoose from "mongoose";
import cors from "cors";

const app = express();
app.use(cors());
app.use(express.json());

const mongoUrl = process.env.MONGO_URL || "mongodb://localhost:27017/tasksdb";
mongoose.connect(mongoUrl)
  .then(() => console.log("✅ MongoDB connected"))
  .catch(err => console.error("❌ MongoDB connection error:", err));

const taskSchema = new mongoose.Schema({
  title: String,
  completed: Boolean
});
const Task = mongoose.model("Task", taskSchema);

// Routes
app.get("/api/tasks", async (req, res) => {
  const tasks = await Task.find();
  res.json(tasks);
});

app.post("/api/tasks", async (req, res) => {
  const { title } = req.body;
  const newTask = new Task({ title, completed: false });
  await newTask.save();
  res.json(newTask);
});

app.put("/api/tasks/:id", async (req, res) => {
  const { id } = req.params;
  const task = await Task.findById(id);
  task.completed = !task.completed;
  await task.save();
  res.json(task);
});

app.delete("/api/tasks/:id", async (req, res) => {
  const { id } = req.params;
  await Task.findByIdAndDelete(id);
  res.json({ message: "Deleted" });
});

const port = 5000;
app.listen(port, () => console.log(`🚀 Backend running on port ${port}`));
