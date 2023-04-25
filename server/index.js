import express from 'express';
import { PORT } from './config.js'
import indexRoutes from './routes/index.routes.js'
import cors from 'cors'

const app = express();

app.use(cors({
    origin: "http://localhost:5173",
    methods: ["GET", "POST", "PUT", "DELETE"]
}));
app.use(express.json());
app.use(indexRoutes);
app.listen(PORT);
console.log(`Server is listening on port ${PORT}`);