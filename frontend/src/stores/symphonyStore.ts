/**
 * Store Zustand para gerenciamento de estado da Symphony of Connection
 * Integrado com WebSocket para colaboração em tempo real
 * @module stores/symphonyStore
 */

import { create } from 'zustand';
import { socketService, SymphonyState, UserState, EmotionalVector } from '../services/socketService';

// Interface estendida para compatibilidade com código existente
interface SymphonyStore {
  // Estado da sinfonia colaborativa
  symphonyState: SymphonyState | null;
  
  // Usuário atual
  currentUser: UserState | null;
  
  // Estado de conexão
  isConnected: boolean;

  // Propriedades para compatibilidade com código legado
  emotionalVector: EmotionalVector;
  audioEnabled: boolean;
  mousePosition: [number, number, number];
  mouseIntensity: number;
  
  // Ações
  setSymphonyState: (state: SymphonyState) => void;
  setCurrentUser: (user: UserState) => void;
  setConnected: (connected: boolean) => void;
  
  // Ações de conexão
  connectToSymphony: () => void;
  disconnectFromSymphony: () => void;
  
  // Ações de atualização
  updateEmotionalVector: (emotionalVector: EmotionalVector) => void;
  updatePosition: (position: [number, number, number]) => void;
  
  // Ações para compatibilidade
  setAudioEnabled: (enabled: boolean) => void;
  setMousePosition: (position: [number, number, number]) => void;
  setMouseIntensity: (intensity: number) => void;
  updateEmotion: (emotion: string, value: number) => void;
  
  // Utilidades
  getOtherUsers: () => UserState[];
  getConnectionStrength: () => number;
}

// Estado emocional padrão
const defaultEmotionalVector: EmotionalVector = {
  joy: 0.5,
  excitement: 0.5,
  calm: 0.5,
  curiosity: 0.5,
  intensity: 0.5,
  fluidity: 0.5,
  connection: 0.5
};

/**
 * Store principal da aplicação
 */
export const useSymphonyStore = create<SymphonyStore>((set, get) => {
  // Configurar callbacks do serviço de socket
  socketService.setSymphonyStateCallback((state: SymphonyState) => {
    const currentUser = get().currentUser;
    set({ 
      symphonyState: state,
      // Atualizar usuário atual se necessário
      currentUser: currentUser ? state.users.find(u => u.id === currentUser.id) || currentUser : currentUser
    });
  });

  socketService.setUserJoinedCallback((data: { user: UserState }) => {
    const { symphonyState } = get();
    if (symphonyState) {
      set({
        symphonyState: {
          ...symphonyState,
          users: [...symphonyState.users, data.user]
        }
      });
    }
  });

  socketService.setUserLeftCallback((data: { userId: string }) => {
    const { symphonyState } = get();
    if (symphonyState) {
      set({
        symphonyState: {
          ...symphonyState,
          users: symphonyState.users.filter(u => u.id !== data.userId)
        }
      });
    }
  });

  socketService.setSymphonyUpdateCallback((state: SymphonyState) => {
    set({ symphonyState: state });
  });

  socketService.setUserPositionUpdateCallback((data: { userId: string; position: [number, number, number] }) => {
    const { symphonyState } = get();
    if (symphonyState) {
      set({
        symphonyState: {
          ...symphonyState,
          users: symphonyState.users.map(u => 
            u.id === data.userId ? { ...u, position: data.position } : u
          )
        }
      });
    }
  });

  socketService.setConnectionChangeCallback((connected: boolean) => {
    set({ isConnected: connected });
    
    if (connected) {
      const socketId = socketService.getSocketId();
      if (socketId) {
        // Criar usuário atual baseado no socket ID
        const currentUser: UserState = {
          id: socketId,
          emotionalVector: defaultEmotionalVector,
          position: [0, 0, 0],
          color: `hsl(${Math.floor(Math.random() * 360)}, 70%, 60%)`,
          connected: true
        };
        set({ currentUser });
      }
    } else {
      set({ currentUser: null });
    }
  });

  return {
    // Estado inicial
    symphonyState: null,
    currentUser: null,
    isConnected: false,
    emotionalVector: defaultEmotionalVector,
    audioEnabled: true,
    mousePosition: [0, 0, 0],
    mouseIntensity: 0.5,

    // Setters básicos
    setSymphonyState: (state) => set({ symphonyState: state }),
    setCurrentUser: (user) => set({ currentUser: user }),
    setConnected: (connected) => set({ isConnected: connected }),

    // Ações de conexão
    connectToSymphony: () => {
      socketService.connect();
      set({ isConnected: true });
    },

    disconnectFromSymphony: () => {
      socketService.disconnect();
      set({ 
        isConnected: false, 
        symphonyState: null, 
        currentUser: null 
      });
    },

    // Ações de atualização
    updateEmotionalVector: (emotionalVector) => {
      const { currentUser } = get();
      set({ emotionalVector });
      
      if (currentUser) {
        const updatedUser = { ...currentUser, emotionalVector };
        set({ currentUser: updatedUser });
        socketService.sendEmotionalUpdate(emotionalVector);
      }
    },

    updatePosition: (position) => {
      const { currentUser } = get();
      set({ mousePosition: position });
      
      if (currentUser) {
        const updatedUser = { ...currentUser, position };
        set({ currentUser: updatedUser });
        socketService.sendPositionUpdate(position);
      }
    },

    // Ações para compatibilidade
    setAudioEnabled: (enabled) => set({ audioEnabled: enabled }),
    
    setMousePosition: (position) => {
      set({ mousePosition: position });
      get().updatePosition(position);
    },
    
    setMouseIntensity: (intensity) => set({ mouseIntensity: intensity }),
    
    updateEmotion: (emotion: string, value: number) => {
      const { emotionalVector } = get();
      const updatedVector = {
        ...emotionalVector,
        [emotion]: Math.max(0, Math.min(1, value))
      };
      get().updateEmotionalVector(updatedVector);
    },

    // Utilidades
    getOtherUsers: () => {
      const { symphonyState, currentUser } = get();
      if (!symphonyState || !currentUser) return [];
      return symphonyState.users.filter(user => user.id !== currentUser.id);
    },

    getConnectionStrength: () => {
      const { symphonyState } = get();
      return symphonyState?.connectionStrength || 0;
    }
  };
});
