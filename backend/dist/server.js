import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';
import cors from 'cors';
const app = express();
const server = createServer(app);
const io = new Server(server, {
    cors: {
        origin: "http://localhost:3000",
        methods: ["GET", "POST"]
    }
});
app.use(cors());
app.use(express.json());
// Estado da sinfonia
const symphonyState = {
    users: [],
    emotionalField: {
        joy: 0.5,
        excitement: 0.3,
        calm: 0.7,
        curiosity: 0.6,
        intensity: 0.4,
        fluidity: 0.5,
        connection: 0.2
    },
    connectionStrength: 0.3
};
io.on('connection', (socket) => {
    console.log('🎵 Usuário conectado:', socket.id);
    // Adicionar usuário ao estado
    const newUser = {
        id: socket.id,
        emotionalVector: { ...symphonyState.emotionalField },
        position: [0, 0, 0],
        color: `hsl(${Math.random() * 360}, 70%, 60%)`,
        connected: true
    };
    symphonyState.users.push(newUser);
    // Enviar estado inicial para o usuário
    socket.emit('symphony-state', {
        users: symphonyState.users,
        emotionalField: symphonyState.emotionalField,
        connectionStrength: symphonyState.connectionStrength
    });
    // Notificar outros usuários
    socket.broadcast.emit('user-joined', {
        user: newUser
    });
    // Lidar com atualizações emocionais
    socket.on('emotional-update', (data) => {
        const userIndex = symphonyState.users.findIndex(u => u.id === socket.id);
        if (userIndex !== -1) {
            symphonyState.users[userIndex].emotionalVector = data.emotionalVector;
            // Atualizar campo emocional geral (média simples)
            const usersArray = symphonyState.users;
            symphonyState.emotionalField = {
                joy: usersArray.reduce((sum, u) => sum + u.emotionalVector.joy, 0) / usersArray.length,
                excitement: usersArray.reduce((sum, u) => sum + u.emotionalVector.excitement, 0) / usersArray.length,
                calm: usersArray.reduce((sum, u) => sum + u.emotionalVector.calm, 0) / usersArray.length,
                curiosity: usersArray.reduce((sum, u) => sum + u.emotionalVector.curiosity, 0) / usersArray.length,
                intensity: usersArray.reduce((sum, u) => sum + u.emotionalVector.intensity, 0) / usersArray.length,
                fluidity: usersArray.reduce((sum, u) => sum + u.emotionalVector.fluidity, 0) / usersArray.length,
                connection: usersArray.reduce((sum, u) => sum + u.emotionalVector.connection, 0) / usersArray.length
            };
            // Calcular força de conexão baseada na similaridade emocional
            const similarities = usersArray.map(u => {
                const vec1 = data.emotionalVector;
                const vec2 = u.emotionalVector;
                const dotProduct = vec1.joy * vec2.joy + vec1.excitement * vec2.excitement +
                    vec1.calm * vec2.calm + vec1.curiosity * vec2.curiosity;
                const magnitude1 = Math.sqrt(vec1.joy ** 2 + vec1.excitement ** 2 + vec1.calm ** 2 + vec1.curiosity ** 2);
                const magnitude2 = Math.sqrt(vec2.joy ** 2 + vec2.excitement ** 2 + vec2.calm ** 2 + vec2.curiosity ** 2);
                return dotProduct / (magnitude1 * magnitude2);
            });
            symphonyState.connectionStrength = similarities.reduce((a, b) => a + b, 0) / similarities.length;
            // Broadcast para todos os usuários
            io.emit('symphony-update', {
                users: symphonyState.users,
                emotionalField: symphonyState.emotionalField,
                connectionStrength: symphonyState.connectionStrength
            });
        }
    });
    // Lidar com desconexão
    socket.on('disconnect', () => {
        console.log('👋 Usuário desconectado:', socket.id);
        symphonyState.users = symphonyState.users.filter(u => u.id !== socket.id);
        // Notificar outros usuários
        socket.broadcast.emit('user-left', { userId: socket.id });
    });
});
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
    console.log(`🎵 Symphony Server rodando na porta ${PORT}`);
    console.log(`🌐 Acesse: http://localhost:${PORT}`);
});
