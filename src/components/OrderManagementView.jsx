import React, { useState } from 'react';
import { 
  ClipboardList, 
  Clock, 
  CheckCircle2, 
  AlertCircle, 
  MessageSquare, 
  ShieldCheck, 
  Upload, 
  ArrowRight, 
  ThumbsUp, 
  AlertTriangle,
  FileCheck,
  CreditCard,
  User,
  Sparkles
} from 'lucide-react';
import { formatRM } from '../utils/security';

export default function OrderManagementView({ 
  orders, 
  onUpdateOrderStatus, 
  onOpenChat, 
  onOpenDispute, 
  onOpenFpx,
  onOpenReview,
  activeRole 
}) {
  const [filterTab, setFilterTab] = useState('all');
  const [uploadModalOrder, setUploadModalOrder] = useState(null);
  const [proofUrl, setProofUrl] = useState('https://images.unsplash.com/photo-1526367790999-0150786686a2?auto=format&fit=crop&w=600&q=80');
  const [deliveryNote, setDeliveryNote] = useState('Tugasan telah disempurnakan dengan rapi dan selamat diserahkan kepada pemohon.');

  const getStatusBadge = (status) => {
    switch (status) {
      case 'MENUNGGU_BAYARAN':
        return <span className="px-2.5 py-0.5 rounded-full bg-slate-200 text-slate-800 text-[10px] font-extrabold">1. Menunggu Bayaran</span>;
      case 'MENUNGGU_TERIMA':
        return <span className="px-2.5 py-0.5 rounded-full bg-amber-100 text-amber-800 text-[10px] font-extrabold flex items-center gap-1"><Clock className="w-3 h-3 animate-spin" /> 2. Menunggu Penerimaan (Escrow Held)</span>;
      case 'SEDANG_DILAKUKAN':
        return <span className="px-2.5 py-0.5 rounded-full bg-blue-100 text-blue-800 text-[10px] font-extrabold">3. Sedang Dilakukan</span>;
      case 'MENUNGGU_PENGESAHAN':
        return <span className="px-2.5 py-0.5 rounded-full bg-purple-100 text-purple-800 text-[10px] font-extrabold">4. Menunggu Pengesahan Kerja</span>;
      case 'SELESAI':
        return <span className="px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800 text-[10px] font-extrabold flex items-center gap-1"><CheckCircle2 className="w-3 h-3" /> 5. Selesai (Dana Dilepaskan)</span>;
      case 'PERTIKAIAN':
        return <span className="px-2.5 py-0.5 rounded-full bg-red-100 text-red-800 text-[10px] font-extrabold flex items-center gap-1"><AlertTriangle className="w-3 h-3" /> 6. Pertikaian (Escrow Beku)</span>;
      case 'DIBATALKAN':
        return <span className="px-2.5 py-0.5 rounded-full bg-slate-200 text-slate-600 text-[10px] font-extrabold">Dibatalkan (Wang Dipulangkan)</span>;
      default:
        return null;
    }
  };

  const filteredOrders = orders.filter((ord) => {
    if (filterTab === 'active') return ['MENUNGGU_BAYARAN', 'MENUNGGU_TERIMA', 'SEDANG_DILAKUKAN', 'MENUNGGU_PENGESAHAN'].includes(ord.order_status);
    if (filterTab === 'completed') return ord.order_status === 'SELESAI';
    if (filterTab === 'dispute') return ['PERTIKAIAN', 'DIBATALKAN'].includes(ord.order_status);
    return true;
  });

  return (
    <div className="space-y-4 p-3 sm:p-5">
      
      {/* Header Info */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-2">
        <div>
          <h2 className="text-lg font-extrabold text-slate-900 tracking-tight flex items-center gap-2">
            <ClipboardList className="w-5 h-5 text-indigo-600" />
            Pengurusan Pesanan & Kitaran Escrow (FR-3.1)
          </h2>
          <p className="text-xs text-slate-500 font-medium">
            Pantau kitaran hidup tugasan dari pembayaran hingga serahan hasil kerja.
          </p>
        </div>

        {/* Tab Filters */}
        <div className="flex items-center bg-slate-100 p-1 rounded-xl text-xs font-bold text-slate-600">
          <button
            onClick={() => setFilterTab('all')}
            className={`px-3 py-1 rounded-lg transition-all ${filterTab === 'all' ? 'bg-white text-slate-900 shadow-sm' : ''}`}
          >
            Semua ({orders.length})
          </button>
          <button
            onClick={() => setFilterTab('active')}
            className={`px-3 py-1 rounded-lg transition-all ${filterTab === 'active' ? 'bg-white text-indigo-600 shadow-sm' : ''}`}
          >
            Aktif
          </button>
          <button
            onClick={() => setFilterTab('completed')}
            className={`px-3 py-1 rounded-lg transition-all ${filterTab === 'completed' ? 'bg-white text-emerald-700 shadow-sm' : ''}`}
          >
            Selesai
          </button>
        </div>
      </div>

      {/* Senarai Pesanan */}
      {filteredOrders.length === 0 ? (
        <div className="bg-white rounded-2xl p-8 text-center border border-dashed border-slate-300">
          <ClipboardList className="w-10 h-10 text-slate-300 mx-auto mb-2" />
          <h4 className="font-bold text-slate-700 text-sm">Tiada pesanan dalam kategori ini</h4>
          <p className="text-xs text-slate-500 mt-1">Buat tempahan baharu di katalog servis untuk bermula.</p>
        </div>
      ) : (
        <div className="space-y-3.5">
          {filteredOrders.map((ord) => (
            <div
              key={ord.order_id}
              className="bg-white rounded-2xl border border-slate-200/90 p-4 shadow-sm space-y-3 hover:border-slate-300 transition-all"
            >
              {/* Kad Header */}
              <div className="flex flex-wrap items-center justify-between gap-2 pb-2.5 border-b border-slate-100">
                <div className="flex items-center gap-2">
                  <span className="font-mono text-xs font-bold text-slate-500">{ord.order_id}</span>
                  <span className="text-[10px] text-slate-400">• {ord.created_at}</span>
                </div>
                <div>{getStatusBadge(ord.order_status)}</div>
              </div>

              {/* Butiran Pesanan */}
              <div className="flex flex-col sm:flex-row justify-between gap-3">
                <div className="space-y-1">
                  <h3 className="font-extrabold text-sm text-slate-900">
                    {ord.service_title}
                  </h3>
                  <div className="flex items-center gap-2 text-xs text-slate-600">
                    <span className="font-medium">Pemohon: <strong>{ord.buyer_name}</strong></span>
                    <span>•</span>
                    <span className="font-medium">Penyedia: <strong>{ord.provider_name}</strong></span>
                  </div>
                  {ord.delivery_note && (
                    <p className="text-[11px] text-slate-500 bg-slate-50 p-2 rounded-lg italic">
                      Nota: "{ord.delivery_note}"
                    </p>
                  )}
                </div>

                {/* Ringkasan Kewangan Escrow */}
                <div className="bg-slate-50 p-2.5 rounded-xl border border-slate-200 text-xs sm:text-right shrink-0 space-y-1 min-w-[170px]">
                  <div className="flex justify-between sm:justify-end gap-2 text-slate-500">
                    <span>Jumlah Bayaran:</span>
                    <strong className="text-slate-800">{formatRM(ord.total_amount)}</strong>
                  </div>
                  <div className="flex justify-between sm:justify-end gap-2 text-[11px] text-slate-500">
                    <span>Komisen (5%):</span>
                    <strong className="text-amber-600">-{formatRM(ord.commission_fee)}</strong>
                  </div>
                  <div className="flex justify-between sm:justify-end gap-2 text-xs font-extrabold text-emerald-700 pt-1 border-t border-slate-200">
                    <span>Bersih Penyedia:</span>
                    <span>{formatRM(ord.net_amount)}</span>
                  </div>
                  <div className="text-[10px] text-slate-400 pt-0.5 flex items-center justify-end gap-1">
                    <ShieldCheck className="w-3 h-3 text-emerald-600" />
                    <span>Status Escrow: <strong className="text-slate-700">{ord.escrow_status}</strong></span>
                  </div>
                </div>
              </div>

              {/* Paparan Bukti Kerja (jika ada) */}
              {ord.proof_file_url && (
                <div className="p-3 bg-purple-50 rounded-xl border border-purple-200/70 flex items-center justify-between gap-3 text-xs">
                  <div className="flex items-center gap-2">
                    <FileCheck className="w-5 h-5 text-purple-600 shrink-0" />
                    <div>
                      <span className="font-bold text-purple-900 block">Bukti Serahan Kerja Siap Dimuat Naik</span>
                      <a href={ord.proof_file_url} target="_blank" rel="noreferrer" className="text-purple-700 underline text-[11px]">
                        Lihat Fail / Tangkap Layar Bukti
                      </a>
                    </div>
                  </div>
                  <img
                    src={ord.proof_file_url}
                    alt="Proof"
                    className="w-10 h-10 rounded-lg object-cover border border-purple-200"
                  />
                </div>
              )}

              {/* Bar Tindakan Interaktif Mengikut State Machine */}
              <div className="flex flex-wrap items-center justify-between gap-2 pt-2 border-t border-slate-100">
                
                {/* Butang Sembang Dalam Aplikasi (In-App Chat) */}
                <button
                  onClick={() => onOpenChat(ord)}
                  className="px-3 py-1.5 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-bold flex items-center gap-1.5 transition-all"
                >
                  <MessageSquare className="w-3.5 h-3.5 text-indigo-600" />
                  <span>Sembang Pesanan (Chat)</span>
                </button>

                {/* State Machine Action Controls */}
                <div className="flex items-center gap-2 ml-auto">
                  
                  {/* Status 1: MENUNGGU_BAYARAN */}
                  {ord.order_status === 'MENUNGGU_BAYARAN' && (
                    <button
                      onClick={() => onOpenFpx(ord)}
                      className="px-3.5 py-1.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-extrabold shadow-sm flex items-center gap-1"
                    >
                      <CreditCard className="w-3.5 h-3.5" />
                      <span>Bayar FPX Sekarang ({formatRM(ord.total_amount)})</span>
                    </button>
                  )}

                  {/* Status 2: MENUNGGU_TERIMA */}
                  {ord.order_status === 'MENUNGGU_TERIMA' && (
                    <>
                      {/* Cron Simulation Button (TC-ORD-01) */}
                      <button
                        onClick={() => onUpdateOrderStatus(ord.order_id, 'DIBATALKAN', { autoCancel: true })}
                        className="px-2.5 py-1.5 rounded-xl border border-red-200 text-red-600 hover:bg-red-50 text-[11px] font-bold"
                        title="Simulasi jika penyedia tidak respons dalam tempoh 24 jam"
                      >
                        Simulasi Had 24j Tamat
                      </button>

                      <button
                        onClick={() => onUpdateOrderStatus(ord.order_id, 'SEDANG_DILAKUKAN')}
                        className="px-3.5 py-1.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-extrabold shadow-sm flex items-center gap-1"
                      >
                        <Sparkles className="w-3.5 h-3.5" />
                        <span>Penyedia: Terima Tugasan</span>
                      </button>
                    </>
                  )}

                  {/* Status 3: SEDANG_DILAKUKAN */}
                  {ord.order_status === 'SEDANG_DILAKUKAN' && (
                    <button
                      onClick={() => setUploadModalOrder(ord)}
                      className="px-3.5 py-1.5 rounded-xl bg-purple-600 hover:bg-purple-700 text-white text-xs font-extrabold shadow-sm flex items-center gap-1"
                    >
                      <Upload className="w-3.5 h-3.5" />
                      <span>Penyedia: Hantar Bukti Kerja Siap</span>
                    </button>
                  )}

                  {/* Status 4: MENUNGGU_PENGESAHAN */}
                  {ord.order_status === 'MENUNGGU_PENGESAHAN' && (
                    <>
                      {/* Lapor Pertikaian Button (TC-DSP-01) */}
                      <button
                        onClick={() => onOpenDispute(ord)}
                        className="px-2.5 py-1.5 rounded-xl border border-red-300 text-red-700 hover:bg-red-50 text-xs font-bold flex items-center gap-1"
                      >
                        <AlertTriangle className="w-3 h-3" />
                        <span>Lapor Isu / Pertikaian</span>
                      </button>

                      {/* Sahkan Selesai Button (TC-ESC-02) */}
                      <button
                        onClick={() => {
                          onUpdateOrderStatus(ord.order_id, 'SELESAI');
                          onOpenReview(ord);
                        }}
                        className="px-3.5 py-1.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-extrabold shadow-sm flex items-center gap-1"
                      >
                        <ThumbsUp className="w-3.5 h-3.5" />
                        <span>Pemohon: Sahkan Selesai & Lepas Dana</span>
                      </button>
                    </>
                  )}

                  {/* Status 5: SELESAI */}
                  {ord.order_status === 'SELESAI' && (
                    <button
                      onClick={() => onOpenReview(ord)}
                      className="px-3 py-1.5 rounded-xl bg-amber-50 text-amber-800 border border-amber-200 text-xs font-bold"
                    >
                      Ulasan & Penarafan
                    </button>
                  )}

                </div>
              </div>

            </div>
          ))}
        </div>
      )}

      {/* Modal Muat Naik Bukti Kerja Siap (Penyedia) */}
      {uploadModalOrder && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 animate-fadeIn">
          <div className="bg-white rounded-3xl max-w-md w-full p-5 shadow-2xl border border-slate-200 space-y-4">
            <div className="flex justify-between items-center pb-2 border-b border-slate-100">
              <h3 className="font-extrabold text-slate-900 text-sm">
                Muat Naik Bukti Kerja Siap ({uploadModalOrder.order_id})
              </h3>
              <button
                onClick={() => setUploadModalOrder(null)}
                className="text-slate-400 hover:text-slate-600 text-base font-bold"
              >
                ✕
              </button>
            </div>

            <div className="p-3 bg-purple-50 rounded-2xl border border-purple-200 text-xs text-purple-900 flex items-start gap-2">
              <ShieldCheck className="w-4 h-4 text-purple-700 shrink-0 mt-0.5" />
              <span>
                Sebelum pembayaran escrow <strong>{formatRM(uploadModalOrder.total_amount)}</strong> dilepaskan, sila sertakan gambar resit atau hasil kerja untuk disemak oleh pemohon.
              </span>
            </div>

            {/* Pilihan Pantas Bukti Serahan */}
            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1.5">
                Pilih Contoh Bukti Kampus (Pantas 1-Klik):
              </label>
              <div className="flex flex-wrap gap-1.5">
                {[
                  { label: '📦 Resit Makanan', url: 'https://images.unsplash.com/photo-1526367790999-0150786686a2?auto=format&fit=crop&w=600&q=80' },
                  { label: '💻 Format Laptop SSD', url: 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=600&q=80' },
                  { label: '📚 Hardcover Tesis', url: 'https://images.unsplash.com/photo-1568667256549-094345857637?auto=format&fit=crop&w=600&q=80' },
                  { label: '🎓 Tutor & Nota', url: 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&w=600&q=80' },
                  { label: '🧺 Dobi Siap Lipat', url: 'https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?auto=format&fit=crop&w=600&q=80' },
                ].map((preset) => (
                  <button
                    key={preset.label}
                    type="button"
                    onClick={() => setProofUrl(preset.url)}
                    className={`text-[11px] px-2.5 py-1 rounded-lg border font-semibold transition-all ${
                      proofUrl === preset.url
                        ? 'bg-purple-600 text-white border-purple-600 shadow-sm'
                        : 'bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100'
                    }`}
                  >
                    {preset.label}
                  </button>
                ))}
              </div>
            </div>

            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">
                Pautan Imej / Dokumen Bukti (URL)
              </label>
              <input
                type="url"
                value={proofUrl}
                onChange={(e) => setProofUrl(e.target.value)}
                className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-mono text-slate-700 outline-none focus:ring-2 focus:ring-purple-500"
              />
              <div className="mt-2 h-32 rounded-xl overflow-hidden border border-slate-200 bg-slate-100">
                <img src={proofUrl} alt="Preview Bukti" className="w-full h-full object-cover" />
              </div>
            </div>

            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">
                Nota Serahan / Mesej untuk Pemohon
              </label>
              <textarea
                rows={2}
                value={deliveryNote}
                onChange={(e) => setDeliveryNote(e.target.value)}
                placeholder="Cth: Servis siap diserahkan depan kolej jam 2 ptg."
                className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 text-slate-700 outline-none focus:ring-2 focus:ring-purple-500"
              />
            </div>

            <div className="pt-2">
              <button
                onClick={() => {
                  onUpdateOrderStatus(uploadModalOrder.order_id, 'MENUNGGU_PENGESAHAN', { proofUrl, deliveryNote });
                  setUploadModalOrder(null);
                }}
                className="w-full py-2.5 rounded-xl bg-purple-600 hover:bg-purple-700 text-white font-extrabold text-xs shadow-md transition-all flex items-center justify-center gap-1.5"
              >
                <CheckCircle2 className="w-4 h-4" />
                <span>Hantar kepada Pemohon untuk Disahkan</span>
              </button>
            </div>
          </div>
        </div>
      )}

    </div>
  );
}

