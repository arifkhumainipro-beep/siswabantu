import React, { useState } from 'react';
import { 
  AlertTriangle, 
  ShieldAlert, 
  Upload, 
  CheckCircle2, 
  X, 
  FileText 
} from 'lucide-react';

export default function DisputeModal({ order, onClose, onSubmitDispute }) {
  const [reason, setReason] = useState('Hasil kerja tidak mengikut spesifikasi dan perisian gagal berfungsi.');
  const [evidenceUrl, setEvidenceUrl] = useState('https://images.unsplash.com/photo-1597872200969-2b65d56bd16b?auto=format&fit=crop&w=400&q=80');

  if (!order) return null;

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!reason.trim()) return;

    onSubmitDispute({
      dispute_id: `DSP-${Date.now()}`,
      order_id: order.order_id,
      service_title: order.service_title,
      raised_by_id: order.buyer_id,
      raised_by_name: order.buyer_name,
      provider_name: order.provider_name,
      amount: order.total_amount,
      reason,
      evidence_url: evidenceUrl,
      status: 'Open',
      created_at: new Date().toLocaleString('ms-MY'),
    });

    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/65 backdrop-blur-sm flex items-center justify-center p-4 animate-fadeIn">
      <div className="bg-white rounded-3xl max-w-md w-full p-5 sm:p-6 shadow-2xl border border-slate-200 space-y-4">
        
        {/* Header */}
        <div className="flex justify-between items-center pb-2 border-b border-slate-100">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-xl bg-rose-100 text-rose-600 flex items-center justify-center">
              <AlertTriangle className="w-4 h-4" />
            </div>
            <div>
              <h3 className="font-extrabold text-sm sm:text-base text-slate-900">
                Pusat Resolusi & Pertikaian (FR-5.2)
              </h3>
              <p className="text-[11px] text-slate-500 font-medium">
                Pembekuan Dana Escrow Serta-merta
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="w-7 h-7 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 flex items-center justify-center text-sm font-bold"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Warning Alert Notice */}
        <div className="bg-rose-50 border border-rose-200 rounded-2xl p-3.5 text-xs text-rose-800 space-y-1.5">
          <div className="flex items-center gap-2 font-bold text-rose-700">
            <ShieldAlert className="w-4 h-4 shrink-0" />
            <span>Kesan Pembukaan Pertikaian (TC-DSP-01):</span>
          </div>
          <p className="leading-relaxed">
            1. Dana Escrow bernilai <strong>RM {order.total_amount.toFixed(2)}</strong> akan <strong>dibekukan serta-merta</strong>.
          </p>
          <p className="leading-relaxed">
            2. Pemasa pelepasan automatik 72 jam <strong>dihentikan serta-merta</strong>.
          </p>
          <p className="leading-relaxed">
            3. Panel Pentadbir SiswaBantu akan menyemak bukti serahan dan log sembang untuk timbang tara muktamad.
          </p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-3.5">
          <div>
            <div className="flex justify-between items-center mb-1">
              <label className="text-xs font-bold text-slate-700 block">
                Sebab Pertikaian / Aduan *
              </label>
            </div>
            {/* Quick Presets */}
            <div className="flex flex-wrap gap-1.5 mb-2">
              {[
                'Hasil kerja tidak lengkap',
                'Penyedia gagal dihubungi',
                'Kualiti tidak mengikut taklimat',
                'Kelewatan melebihi SLA'
              ].map((preset) => (
                <button
                  key={preset}
                  type="button"
                  onClick={() => setReason(preset)}
                  className="px-2 py-0.5 rounded-lg bg-slate-100 hover:bg-slate-200 text-[10px] font-semibold text-slate-700 transition-colors"
                >
                  {preset}
                </button>
              ))}
            </div>
            <textarea
              required
              rows={3}
              value={reason}
              onChange={(e) => setReason(e.target.value)}
              placeholder="Jelaskan secara terperinci apa yang tidak memuaskan atau mengapa tugasan tidak siap..."
              className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-medium outline-none focus:ring-2 focus:ring-rose-500"
            />
          </div>

          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">
              Pautan Bukti Tangkap Layar Ralat / Dokumen (URL) *
            </label>
            <input
              type="url"
              required
              value={evidenceUrl}
              onChange={(e) => setEvidenceUrl(e.target.value)}
              className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2 font-mono text-slate-700 outline-none focus:ring-2 focus:ring-rose-500"
            />
            {evidenceUrl && (
              <div className="mt-2 h-24 rounded-xl overflow-hidden border border-slate-200 bg-slate-100">
                <img src={evidenceUrl} alt="Preview Bukti" className="w-full h-full object-cover" />
              </div>
            )}
          </div>

          <div className="pt-2">
            <button
              type="submit"
              className="w-full py-3 rounded-xl bg-rose-600 hover:bg-rose-700 text-white font-extrabold text-xs shadow-md shadow-rose-500/20 flex items-center justify-center gap-2 active:scale-95 transition-all"
            >
              <AlertTriangle className="w-4 h-4" />
              <span>Hantar Aduan & Bekukan Escrow Sekarang (TC-DSP-01)</span>
            </button>
          </div>
        </form>

      </div>
    </div>
  );
}

