/**
 * Serviço de Socket Client para Symphony of Connection
 * Integração com backend WebSocket existente
 * @module services/socketService
 */

import { io, Socket } from 'socket.io-client';

/**
 * Vetor emocional com 7 dimensões
 */
export interface EmotionalVector {
  joy: number;
  excitement: number;
  calm: number;
  curiosity: number;
  intensity: number;
  fluidity: number;
  connection: number;
}

/**
 * Estado do usuário na sinfonia
 */
export interface UserState {
  id: string;
  emotionalVector: EmotionalVector;
  position: [number, number, number];
  color: string;
  connected: boolean;
}

/**
 * Estado completo da sinfonia colaborativa
 */
export interface SymphonyState {
  users: UserState[];
  emotionalField: EmotionalVector;
  connectionStrength: number;
}

/**
 * Serviço de gerenciamento de conexão WebSocket
 */
class SocketService {
  private socket: Socket | null = null;
  private isConnected: boolean = false;
  private reconnectAttempts: number = 0;
  private readonly maxReconnectAttempts: number = 5;

  // Callbacks para eventos do socket
  private onSymphonyState: ((state: SymphonyState) => void) | null = null;
  private onUserJoined: ((data: { user: UserState }) => void) | null = null;
  private onUserLeft: ((data: { userId: string }) => void) | null = null;
  private onSymphonyUpdate: ((state: SymphonyState) => void) | null = null;
  private onUserPositionUpdate: ((data: { userId: string; position: [number, number, number] }) => void) | null = null;
  private onConnectionChange: ((connected: boolean) => void) | null = null;

  /**
   * Conecta ao servidor WebSocket
   */
  connect(): void {
    if (this.socket && this.isConnected) {
      console.log('🔗 Socket já conectado');
      return;
    }

    try {
      this.socket = io('http://localhost:5000', {
        timeout: 10000,
        reconnectionAttempts: this.maxReconnectAttempts,
        transports: ['websocket', 'polling']
      });

      this.setupEventListeners();
      console.log('🔌 Iniciando conexão WebSocket...');

    } catch (error) {
      console.error('❌ Erro ao conectar com servidor:', error);
    }
  }

  /**
   * Configura os listeners de eventos do socket
   */
  private setupEventListeners(): void {
    if (!this.socket) return;

    this.socket.on('connect', () => {
      console.log('🔗 Conectado ao servidor de colaboração');
      this.isConnected = true;
      this.reconnectAttempts = 0;
      this.onConnectionChange?.(true);
    });

    this.socket.on('disconnect', (reason: string) => {
      console.log('🔌 Desconectado do servidor:', reason);
      this.isConnected = false;
      this.onConnectionChange?.(false);
    });

    this.socket.on('symphony-state', (state: SymphonyState) => {
      console.log(`🎵 Estado da sinfonia recebido: ${state.users.length} usuários`);
      this.onSymphonyState?.(state);
    });

    this.socket.on('user-joined', (data: { user: UserState }) => {
      console.log('✨ Novo usuário entrou:', data.user.id);
      this.onUserJoined?.(data);
    });

    this.socket.on('user-left', (data: { userId: string }) => {
      console.log('👋 Usuário saiu:', data.userId);
      this.onUserLeft?.(data);
    });

    this.socket.on('symphony-update', (state: SymphonyState) => {
      this.onSymphonyUpdate?.(state);
    });

    this.socket.on('user-position-update', (data: { userId: string; position: [number, number, number] }) => {
      this.onUserPositionUpdate?.(data);
    });

    this.socket.on('connect_error', (error: Error) => {
      console.error('❌ Erro de conexão:', error.message);
      this.reconnectAttempts++;
    });

    this.socket.on('reconnect_attempt', (attempt: number) => {
      console.log(`🔄 Tentativa de reconexão ${attempt}/${this.maxReconnectAttempts}`);
    });

    this.socket.on('pong', (data: { timestamp: number }) => {
      console.log('🏓 Pong recebido:', new Date(data.timestamp).toISOString());
    });
  }

  // Métodos públicos para configuração de callbacks

  setSymphonyStateCallback(callback: (state: SymphonyState) => void): void {
    this.onSymphonyState = callback;
  }

  setUserJoinedCallback(callback: (data: { user: UserState }) => void): void {
    this.onUserJoined = callback;
  }

  setUserLeftCallback(callback: (data: { userId: string }) => void): void {
    this.onUserLeft = callback;
  }

  setSymphonyUpdateCallback(callback: (state: SymphonyState) => void): void {
    this.onSymphonyUpdate = callback;
  }

  setUserPositionUpdateCallback(callback: (data: { userId: string; position: [number, number, number] }) => void): void {
    this.onUserPositionUpdate = callback;
  }

  setConnectionChangeCallback(callback: (connected: boolean) => void): void {
    this.onConnectionChange = callback;
  }

  /**
   * Envia atualização emocional para o servidor
   */
  sendEmotionalUpdate(emotionalVector: EmotionalVector): void {
    if (this.isConnected && this.socket) {
      this.socket.emit('emotional-update', { emotionalVector });
    } else {
      console.warn('⚠️ Socket não conectado para enviar atualização emocional');
    }
  }

  /**
   * Envia atualização de posição para o servidor
   */
  sendPositionUpdate(position: [number, number, number]): void {
    if (this.isConnected && this.socket) {
      this.socket.emit('position-update', { position });
    }
  }

  /**
   * Envia ping para verificar conexão
   */
  ping(): void {
    if (this.socket) {
      this.socket.emit('ping');
    }
  }

  /**
   * Desconecta do servidor
   */
  disconnect(): void {
    if (this.socket) {
      this.socket.disconnect();
      this.socket = null;
      this.isConnected = false;
      console.log('🔌 Socket desconectado');
    }
  }

  /**
   * Retorna status da conexão
   */
  getConnectionStatus(): boolean {
    return this.isConnected;
  }

  /**
   * Retorna o ID do socket (se conectado)
   */
  getSocketId(): string | null {
    return this.socket?.id || null;
  }
}

// Exportar instância singleton
export const socketService = new SocketService();
