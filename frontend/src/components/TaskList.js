import React from "react";

export default function TaskList({ tasks, toggleTask, deleteTask }) {
  return (
    <ul style={{ listStyle: "none", padding: 0 }}>
      {tasks.map((t) => (
        <li key={t._id} style={{ margin: "10px 0" }}>
          <span
            style={{
              textDecoration: t.completed ? "line-through" : "none",
              marginRight: "10px"
            }}
          >
            {t.title}
          </span>
          <button onClick={() => toggleTask(t._id)}>Toggle</button>
          <button onClick={() => deleteTask(t._id)} style={{ marginLeft: "10px" }}>
            Delete
          </button>
        </li>
      ))}
    </ul>
  );
}
