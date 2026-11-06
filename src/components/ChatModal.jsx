import React, { useState, useEffect, useRef } from 'react';
import { 
  Send, 
  MapPin, 
  Paperclip, 
  Image as ImageIcon, 
  ShieldAlert, 
  X, 
  AlertCircle, 
  CheckCheck,
  Building,
  Sparkles
} from 'lucide-react';
import { sanitizeChatMessage } from '../utils/security';

export default function ChatModal({ 
  order, 
  currentUser, 
  onClose,
  initialChats = [],
  onSendMessage
}) {
  const [messages, setMessages] = useState(initialChats);
  const [inputText, setInputText] = useState('');
  const [securityAlert, setSecurityAlert] = useState(null);
  const messagesEndRef = useRef(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  const handleSend = (textToSend = null) => {
    const text = textToSend || inputText;
    if (!text || !text.trim()) return;

    // FR-3.3 & TC-CHT-01: Penapisan Keselamatan Sembang (Anti-Bypass Regex Filter)
    const filterResult = sanitizeChatMessage(text);

    if (filterResult.hasViolation) {
      setSecurityAlert({
        type: filterResult.violationType,
        message: filterResult.warningMessage
      });
    } else {
      setSecurityAlert(null);
    }

    const newMsg = {
      id: `msg-${Date.now()}`,
      sender_id: currentUser?.user_id,
      sender_name: currentUser?.full_name,
      text: filterResult.sanitizedText,
      timestamp: new Date().toLocaleTimeString('ms-MY', { hour: '2-digit', minute: '2-digit' }),
      is_warning: filterResult.hasViolation,
      warning_text: filterResult.hasViolation ? filterResult.warningMessage : null
    };

    const updated = [...messages, newMsg];
    setMessages(updated);
    if (onSendMessage) onSendMessage(order.order_id, updated);
    setInputText('');
  };

  // Quick preset shortcuts for students
  const sendLocationPin = () => {
    handleSend('📍 Pin Lokasi Kampus: Lobi Kolej Mawar Blok C (UiTM Shah Alam)');
  };

  const testScamBypass = () => {
    // Data Ujian dari TC-CHT-01 STD:
    // "Tolong transfer terus ke Maybank saya 162106123456 tak payah guna app"
    handleSend('Tolong transfer terus ke Maybank saya 162106123456 tak payah guna app');
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-3 sm:p-4 animate-fadeIn">
      <div className="bg-white rounded-3xl max-w-lg w-full h-[650px] max-h-[92vh] flex flex-col shadow-2xl border border-slate-200 overflow-hidden">
        
        {/* Chat Header */}
        <div className="px-4 py-3 bg-gradient-to-r from-indigo-700 via-indigo-600 to-cyan-600 text-white flex items-center justify-between shadow-sm">
          <div className="flex items-center gap-2.5">
            <div className="relative">
              <div className="w-10 h-10 rounded-full bg-white/20 border border-white/30 flex items-center justify-center font-bold text-sm">
                {order.buyer_id === currentUser?.user_id ? order.provider_name.charAt(0) : order.buyer_name.charAt(0)}
              </div>
              <span className="absolute bottom-0 right-0 w-2.5 h-2.5 bg-emerald-400 rounded-full border-2 border-indigo-700" />
            </div>
            <div>
              <h3 className="font-extrabold text-sm leading-tight">
                {order.buyer_id === currentUser?.user_id ? order.provider_name : order.buyer_name}
              </h3>
              <p className="text-[11px] text-white/80 line-clamp-1">
                {order.service_title}
              </p>
            </div>
          </div>

          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full bg-black/20 hover:bg-black/30 flex items-center justify-center text-white transition-all"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Anti-Bypass Banner Indicator */}
        <div className="bg-slate-50 px-4 py-2 border-b border-slate-200 flex items-center justify-between text-[11px] text-slate-600">
          <div className="flex items-center gap-1.5 font-medium">
            <ShieldAlert className="w-3.5 h-3.5 text-selangor-red" />
            <span>Anti-Bypass Regex Scanner Aktif (FR-3.3)</span>
          </div>
          <button
            onClick={testScamBypass}
            className="px-2 py-0.5 rounded bg-selangor-yellow text-slate-900 font-bold hover:brightness-105 transition-all"
            title="Klik untuk uji ujian cubaan scam luar aplikasi (TC-CHT-01)"
          >
            Uji Scam Regex (TC-CHT-01)
          </button>
        </div>

        {/* Security Alert Toast if Triggered */}
        {securityAlert && (
          <div className="bg-red-50 border-b border-red-200 p-3 flex items-start gap-2.5 text-xs text-red-700 animate-slideDown">
            <AlertCircle className="w-4 h-4 text-selangor-red shrink-0 mt-0.5" />
            <div>
              <strong className="block font-bold">Amaran Keselamatan (Scam Prevention):</strong>
              <span>{securityAlert.message}</span>
            </div>
          </div>
        )}

        {/* Messages List Area */}
        <div className="flex-1 overflow-y-auto p-4 space-y-3 bg-slate-50/70">
          {messages.map((msg) => {
            const isMe = msg.sender_id === currentUser?.user_id;

            return (
              <div
                key={msg.id}
                className={`flex flex-col ${isMe ? 'items-end' : 'items-start'}`}
              >
                <div
                  className={`max-w-[85%] rounded-2xl px-3.5 py-2.5 text-xs shadow-sm space-y-1 ${
                    isMe
                      ? msg.is_warning
                        ? 'bg-red-600 text-white rounded-br-none ring-2 ring-red-400'
                        : 'bg-selangor-red text-white rounded-br-none'
                      : 'bg-white text-slate-800 rounded-bl-none border border-slate-200'
                  }`}
                >
                  <p className="leading-relaxed whitespace-pre-wrap">{msg.text}</p>
                  
                  {msg.is_warning && (
                    <div className="pt-1.5 mt-1 border-t border-white/20 text-[10px] bg-black/20 p-1.5 rounded-lg font-semibold flex items-center gap-1">
                      <AlertCircle className="w-3 h-3 shrink-0" />
                      <span>{msg.warning_text}</span>
                    </div>
                  )}

                  <div className={`flex items-center justify-end gap-1 text-[9px] ${isMe ? 'text-white/75' : 'text-slate-400'}`}>
                    <span>{msg.timestamp}</span>
                    {isMe && <CheckCheck className="w-3 h-3 text-white/90" />}
                  </div>
                </div>
              </div>
            );
          })}
          <div ref={messagesEndRef} />
        </div>

        {/* Preset Quick Chips */}
        <div className="px-3 py-1.5 bg-white border-t border-slate-100 flex items-center gap-1.5 overflow-x-auto scrollbar-none text-[11px]">
          <button
            onClick={() => handleSend('Salam, saya dah buat bayaran ke Escrow ya.')}
            className="px-2.5 py-1 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-700 whitespace-nowrap"
          >
            Bayaran Escrow Selesai
          </button>
          <button
            onClick={sendLocationPin}
            className="px-2.5 py-1 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-700 whitespace-nowrap flex items-center gap-1"
          >
            <MapPin className="w-3 h-3 text-selangor-red" />
            Pin Lokasi Bilik Kolej
          </button>
          <button
            onClick={() => handleSend('Boleh tolong hantarkan gambar resit makanan sekali?')}
            className="px-2.5 py-1 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-700 whitespace-nowrap"
          >
            Minta Resit
          </button>
        </div>

        {/* Input Bar */}
        <div className="p-3 bg-white border-t border-slate-200 flex items-center gap-2">
          <button
            onClick={sendLocationPin}
            className="p-2 rounded-xl text-slate-400 hover:text-indigo-600 hover:bg-indigo-50 transition-all"
            title="Kongsi Pin Lokasi Kampus"
          >
            <MapPin className="w-4 h-4" />
          </button>
          <button
            onClick={() => handleSend('📎 Fail Tugasan Dihantar: spec_tugasan.pdf (2.4MB)')}
            className="p-2 rounded-xl text-slate-400 hover:text-slate-600 hover:bg-slate-100 transition-all"
            title="Lampir Fail / Dokumen"
          >
            <Paperclip className="w-4 h-4" />
          </button>
          
          <input
            type="text"
            value={inputText}
            onChange={(e) => setInputText(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleSend()}
            placeholder="Tulis mesej selamat..."
            className="flex-1 text-xs bg-slate-50 border border-slate-200 rounded-xl px-3 py-2.5 outline-none focus:ring-2 focus:ring-indigo-600 text-slate-800"
          />

          <button
            onClick={() => handleSend()}
            disabled={!inputText.trim()}
            className="p-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 disabled:opacity-40 text-white shadow-sm transition-all"
          >
            <Send className="w-4 h-4" />
          </button>
        </div>

      </div>
    </div>
  );
}

