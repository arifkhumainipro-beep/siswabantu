import React, { useState } from 'react';
import { 
  SlidersHorizontal, 
  TrendingUp, 
  ShieldCheck, 
  AlertTriangle, 
  Users, 
  CheckCircle2, 
  XCircle, 
  ArrowRight, 
  RotateCcw, 
  Split, 
  FileCheck,
  Building2,
  DollarSign,
  Download,
  Zap
} from 'lucide-react';
import StdTestRunner from './StdTestRunner';
import { formatRM } from '../utils/security';

export default function AdminDashboard({ 
  disputes, 
  onResolveDispute, 
  orders, 
  users 
}) {
  const [activeTab, setActiveTab] = useState('disputes'); // disputes | kyc | transactions | tests

  // Kiraan Kewangan Admin
  const totalVolume = orders.reduce((sum, o) => sum + (o.total_amount || 0), 0) + 4200;
  const platformRevenue = orders.reduce((sum, o) => sum + (o.commission_fee || 0), 0) + 210;
  const escrowHeldTotal = orders.filter(o => o.escrow_status === 'Held').reduce((sum, o) => sum + o.total_amount, 0) + 120;

  return (
    <div className="max-w-7xl mx-auto p-4 sm:p-6 lg:p-8 space-y-6">
      
      {/* Top Banner Admin */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-slate-900 text-white p-6 sm:p-8 rounded-3xl shadow-xl">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <span className="px-2.5 py-0.5 rounded-full bg-indigo-600 text-white text-[10px] font-extrabold uppercase tracking-wider">
              PORTAL RASMI PENTADBIR
            </span>
            <span className="text-xs text-slate-400">Pusat Kawalan & Pemantauan Ekonomi Gig IPTA</span>
          </div>
          <h1 className="text-xl sm:text-2xl font-extrabold tracking-tight">
            Papan Pemuka Pentadbir SiswaBantu
          </h1>
          <p className="text-xs text-slate-300 mt-1 max-w-xl">
            Sistem pengurusan berpusat: semakan e-KYC Kad Matrik, resolusi timbang tara pertikaian escrow, jejak audit kewangan, dan pelari ujian piawaian IEEE Std 829.
          </p>
        </div>

        <div className="flex items-center gap-2">
          <span className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-emerald-500/20 text-emerald-300 border border-emerald-500/30 text-xs font-bold">
            <span className="w-2 h-2 rounded-full bg-emerald-400 animate-ping" />
            Sistem Aktif (Uptime 99.9%)
          </span>
        </div>
      </div>

      {/* KPI Cards Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-white p-5 rounded-2xl border border-slate-200/90 shadow-sm space-y-1">
          <div className="flex justify-between items-center text-slate-500 text-xs">
            <span>Jumlah Nilai Dagangan (GMV)</span>
            <TrendingUp className="w-4 h-4 text-emerald-600" />
          </div>
          <div className="text-2xl font-extrabold text-slate-900">{formatRM(totalVolume)}</div>
          <span className="text-[10px] text-emerald-600 font-bold block">+18.4% bulan ini</span>
        </div>

        <div className="bg-white p-5 rounded-2xl border border-slate-200/90 shadow-sm space-y-1">
          <div className="flex justify-between items-center text-slate-500 text-xs">
            <span>Amanah Escrow Dipegang</span>
            <ShieldCheck className="w-4 h-4 text-indigo-600" />
          </div>
          <div className="text-2xl font-extrabold text-indigo-600">{formatRM(escrowHeldTotal)}</div>
          <span className="text-[10px] text-slate-400 font-medium block">Simpanan selamat di akaun amanah</span>
        </div>

        <div className="bg-white p-5 rounded-2xl border border-slate-200/90 shadow-sm space-y-1">
          <div className="flex justify-between items-center text-slate-500 text-xs">
            <span>Hasil Komisen 5% SiswaBantu</span>
            <DollarSign className="w-4 h-4 text-cyan-600" />
          </div>
          <div className="text-2xl font-extrabold text-cyan-700">{formatRM(platformRevenue)}</div>
          <span className="text-[10px] text-slate-500 font-medium block">Model kelestarian kewangan IPTA</span>
        </div>

        <div className="bg-white p-5 rounded-2xl border border-slate-200/90 shadow-sm space-y-1">
          <div className="flex justify-between items-center text-slate-500 text-xs">
            <span>Mahasiswa Aktif Terverifikasi</span>
            <Users className="w-4 h-4 text-blue-600" />
          </div>
          <div className="text-2xl font-extrabold text-slate-900">1,248</div>
          <span className="text-[10px] text-blue-600 font-bold block">Merentasi 21 IPTA Seluruh Malaysia</span>
        </div>
      </div>

      {/* Admin Tab Switcher */}
      <div className="flex flex-wrap items-center gap-2 border-b border-slate-200 pb-2">
        <button
          onClick={() => setActiveTab('disputes')}
          className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-extrabold transition-all ${
            activeTab === 'disputes'
              ? 'bg-indigo-600 text-white shadow-sm shadow-indigo-500/20'
              : 'text-slate-600 hover:bg-slate-100'
          }`}
        >
          <AlertTriangle className="w-4 h-4" />
          <span>Pusat Resolusi Pertikaian ({disputes.filter(d => d.status === 'Open').length})</span>
        </button>

        <button
          onClick={() => setActiveTab('kyc')}
          className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-extrabold transition-all ${
            activeTab === 'kyc'
              ? 'bg-indigo-600 text-white shadow-sm shadow-indigo-500/20'
              : 'text-slate-600 hover:bg-slate-100'
          }`}
        >
          <FileCheck className="w-4 h-4" />
          <span>Barisan e-KYC Kad Matrik</span>
        </button>

        <button
          onClick={() => setActiveTab('transactions')}
          className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-extrabold transition-all ${
            activeTab === 'transactions'
              ? 'bg-indigo-600 text-white shadow-sm shadow-indigo-500/20'
              : 'text-slate-600 hover:bg-slate-100'
          }`}
        >
          <Building2 className="w-4 h-4" />
          <span>Audit Log Escrow Transaksi</span>
        </button>

        <button
          onClick={() => setActiveTab('tests')}
          className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-extrabold transition-all ${
            activeTab === 'tests'
              ? 'bg-cyan-600 text-white shadow-sm shadow-cyan-500/20'
              : 'text-slate-600 hover:bg-slate-100'
          }`}
        >
          <Zap className="w-4 h-4 text-white fill-white" />
          <span>Ujian STD (IEEE Std 829)</span>
        </button>
      </div>

      {/* Tab Content 1: Pusat Resolusi Pertikaian (FR-5.2) */}
      {activeTab === 'disputes' && (
        <div className="space-y-4">
          <div className="flex justify-between items-center">
            <h3 className="font-extrabold text-sm text-slate-900">
              Kes Pertikaian Terbuka (Dispute Arbitration Desk)
            </h3>
            <span className="text-xs text-slate-500">
              Admin mempunyai kuasa statutori melepaskan atau memulangkan dana Escrow.
            </span>
          </div>

          {disputes.length === 0 ? (
            <div className="bg-white rounded-2xl p-8 text-center border border-dashed border-slate-300">
              <CheckCircle2 className="w-10 h-10 text-emerald-500 mx-auto mb-2" />
              <h4 className="font-bold text-slate-800 text-sm">Tiada pertikaian terbuka</h4>
              <p className="text-xs text-slate-500 mt-1">Semua transaksi berjalan lancar tanpa bantahan.</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 gap-4">
              {disputes.map((dsp) => (
                <div
                  key={dsp.dispute_id}
                  className="bg-white rounded-2xl border border-red-200 p-5 shadow-sm space-y-4"
                >
                  <div className="flex flex-wrap items-center justify-between gap-2 pb-3 border-b border-slate-100">
                    <div className="flex items-center gap-2">
                      <span className="px-2.5 py-0.5 rounded-full bg-red-100 text-red-800 font-mono text-xs font-extrabold">
                        {dsp.dispute_id}
                      </span>
                      <span className="text-xs text-slate-500">Pesanan: {dsp.order_id}</span>
                    </div>

                    <div className="flex items-center gap-2">
                      <span className="text-xs text-slate-600">Dana Tersekat:</span>
                      <strong className="text-base font-extrabold text-selangor-red">
                        {formatRM(dsp.amount)}
                      </strong>
                    </div>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
                    <div className="space-y-2">
                      <p><strong>Servis:</strong> {dsp.service_title}</p>
                      <p><strong>Aduan Dibuat Oleh:</strong> {dsp.raised_by_name} (Pemohon Bantu)</p>
                      <p><strong>Penyedia Terlibat:</strong> {dsp.provider_name}</p>
                      <div className="bg-red-50 p-3 rounded-xl border border-red-200 text-red-900">
                        <strong>Keterangan Aduan:</strong>
                        <p className="mt-1 leading-relaxed">"{dsp.reason}"</p>
                      </div>
                    </div>

                    <div className="space-y-2">
                      <span className="font-bold text-slate-700 block">Bukti yang Dilampirkan:</span>
                      <div className="h-32 rounded-xl overflow-hidden border border-slate-200 bg-slate-100">
                        <img src={dsp.evidence_url} alt="Bukti Ralat" className="w-full h-full object-cover" />
                      </div>
                    </div>
                  </div>

                  {/* Tindakan Timbang Tara Muktamad Admin (FR-5.2) */}
                  {dsp.status === 'Open' ? (
                    <div className="pt-3 border-t border-slate-100 flex flex-wrap items-center justify-between gap-2">
                      <span className="text-xs font-bold text-slate-700">
                        Pilih Keputusan Muktamad Admin (FR-5.2):
                      </span>

                      <div className="flex items-center gap-2">
                        {/* Pilihan (a): Pulangkan 100% wang kepada Pemohon */}
                        <button
                          onClick={() => onResolveDispute(dsp.dispute_id, 'refund_100')}
                          className="px-3 py-1.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs flex items-center gap-1 shadow-sm transition-all"
                        >
                          <RotateCcw className="w-3.5 h-3.5" />
                          <span>(a) Pulangkan 100% ke Pemohon</span>
                        </button>

                        {/* Pilihan (b): Lepaskan 100% wang kepada Penyedia */}
                        <button
                          onClick={() => onResolveDispute(dsp.dispute_id, 'release_100')}
                          className="px-3 py-1.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs flex items-center gap-1 shadow-sm transition-all"
                        >
                          <CheckCircle2 className="w-3.5 h-3.5" />
                          <span>(b) Lepaskan 100% ke Penyedia</span>
                        </button>

                        {/* Pilihan (c): Pembahagian separa (50/50) */}
                        <button
                          onClick={() => onResolveDispute(dsp.dispute_id, 'split_50_50')}
                          className="px-3 py-1.5 rounded-xl bg-amber-600 hover:bg-amber-700 text-white font-bold text-xs flex items-center gap-1 shadow-sm transition-all"
                        >
                          <Split className="w-3.5 h-3.5" />
                          <span>(c) Pembahagian Separa (50/50)</span>
                        </button>
                      </div>
                    </div>
                  ) : (
                    <div className="bg-emerald-50 border border-emerald-200 rounded-xl p-3 text-xs text-emerald-800 font-bold flex items-center gap-2">
                      <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                      <span>Pertikaian Telah Diselesaikan oleh Admin: {dsp.admin_resolution}</span>
                    </div>
                  )}

                </div>
              ))}
            </div>
          )}
        </div>
      )}

      {/* Tab Content 2: e-KYC Verification Queue */}
      {activeTab === 'kyc' && (
        <div className="bg-white rounded-2xl border border-slate-200 p-5 space-y-4">
          <h3 className="font-extrabold text-sm text-slate-900">
            Senarai Menunggu Pengesahan Kad Matrik Mahasiswa
          </h3>

          <div className="divide-y divide-slate-100 text-xs">
            <div className="py-3 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <img
                  src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=250&q=80"
                  alt="Siti Sarah"
                  className="w-10 h-10 rounded-full object-cover"
                />
                <div>
                  <strong className="text-slate-900 block">Siti Sarah (UNISEL)</strong>
                  <span className="text-slate-500 font-mono">No. Matrik: 2026334422 • 20263344@student.unisel.edu.my</span>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <span className="px-2 py-1 rounded bg-amber-100 text-amber-800 font-bold">OCR Match 98%</span>
                <button className="px-3 py-1 rounded-lg bg-emerald-600 text-white font-bold">Luluskan</button>
              </div>
            </div>

            <div className="py-3 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <img
                  src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80"
                  alt="Aiman Hakimi"
                  className="w-10 h-10 rounded-full object-cover"
                />
                <div>
                  <strong className="text-slate-900 block">Aiman Hakimi (UiTM Shah Alam)</strong>
                  <span className="text-slate-500 font-mono">No. Matrik: 2026123456 • 20261234@student.uitm.edu.my</span>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <span className="px-2 py-1 rounded bg-emerald-100 text-emerald-800 font-bold">Disahkan</span>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Tab Content 3: Audit Log Escrow */}
      {activeTab === 'transactions' && (
        <div className="bg-white rounded-2xl border border-slate-200 p-5 space-y-4">
          <div className="flex justify-between items-center">
            <h3 className="font-extrabold text-sm text-slate-900">
              Audit Jejak Log Transaksi Escrow (ACID Compliance)
            </h3>
            <button className="px-3 py-1.5 rounded-xl border border-slate-200 text-xs font-bold text-slate-700 flex items-center gap-1.5 hover:bg-slate-50">
              <Download className="w-3.5 h-3.5" />
              <span>Eksport CSV</span>
            </button>
          </div>

          <table className="w-full text-left text-xs">
            <thead className="bg-slate-50 text-slate-600 border-b border-slate-200 font-bold">
              <tr>
                <th className="p-2.5">ID Pesanan</th>
                <th className="p-2.5">Pemohon</th>
                <th className="p-2.5">Penyedia</th>
                <th className="p-2.5">Jumlah</th>
                <th className="p-2.5">Komisen 5%</th>
                <th className="p-2.5">Status Escrow</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 text-slate-700">
              {orders.map((o) => (
                <tr key={o.order_id} className="hover:bg-slate-50">
                  <td className="p-2.5 font-mono font-bold text-slate-900">{o.order_id}</td>
                  <td className="p-2.5">{o.buyer_name}</td>
                  <td className="p-2.5">{o.provider_name}</td>
                  <td className="p-2.5 font-bold">{formatRM(o.total_amount)}</td>
                  <td className="p-2.5 text-amber-700 font-semibold">{formatRM(o.commission_fee)}</td>
                  <td className="p-2.5">
                    <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold ${
                      o.escrow_status === 'Released'
                        ? 'bg-emerald-100 text-emerald-800'
                        : o.escrow_status === 'Held'
                        ? 'bg-amber-100 text-amber-800'
                        : 'bg-red-100 text-red-800'
                    }`}>
                      {o.escrow_status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* Tab Content 4: Integrated STD Test Runner */}
      {activeTab === 'tests' && (
        <div className="space-y-4">
          <StdTestRunner />
        </div>
      )}

    </div>
  );
}
