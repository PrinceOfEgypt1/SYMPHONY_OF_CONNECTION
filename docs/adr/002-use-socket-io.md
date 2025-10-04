# ADR 002: Uso de Socket.io para WebSockets

## Status  
Aceito - 2024-10-04

## Contexto
Necessidade de comunicação em tempo real para colaboração multi-usuário.

## Decisão
Usar Socket.io para WebSockets.

## Consequências
- Reconexão automática e fallbacks
- Fácil integração com Node.js
- Dependência adicional no projeto
- Protocolo proprietário (não WebSocket puro)
