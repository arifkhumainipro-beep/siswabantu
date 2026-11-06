import React, { useState } from 'react';
import { 
  CreditCard, 
  Building2, 
  ShieldCheck, 
  CheckCircle2, 
  X, 
  Lock, 
  Sparkles,
  ArrowRight
} from 'lucide-react';
import { formatRM } from '../utils/security';

const BANKS = [
  { id: 'mb2u', name: 'Maybank2u', logo: '🟡' },
  { id: 'cimb', name: 'CIMB Clicks', logo: '🔴' },
  { id: 'bankislam', name: 'Bank Islam', logo: '🟢' },
  { id: 'rhb', name: 'RHB Now', logo: '🔵' },
  { id: 'tng', name: 'Touch \'n Go eWallet', logo: '🔷' },
  { id: 'bsn', name: 'BSN (Bank Simpanan Nasional)', logo: '🌐' }
];

export default function FpxModal({ order, onClose, onSuccessPayment }) {
  const [selectedBank, setSelectedBank] = useState('mb2u');
  const [step, setStep] = useState('select_bank'); // select_bank | bank_login | processing | success
  const [bankUsername, setBankUsername] = useState('mahasiswa2026');
  const [bankPassword, setBankPassword] = useState('••••••••');

  if (!order) return null;

  const handleSimulatePayment = () => {
    setStep('processing');
    setTimeout(() => {
      setStep('success');
      setTimeout(() => {
        onSuccessPayment(order.order_id);
        onClose();
      }, 1500);
    }, 1200);
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/65 backdrop-blur-sm flex items-center justify-center p-4 animate-fadeIn">
      <div className="bg-white rounded-3xl max-w-md w-full p-5 sm:p-6 shadow-2xl border border-slate-200 space-y-4">
        
        {/* Header */}
        <div className="flex justify-between items-center pb-3 border-b border-slate-100">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center">
              <CreditCard className="w-4 h-4" />
            </div>
            <div>
              <h3 className="font-extrabold text-sm sm:text-base text-slate-900">
                Gerbang FPX & Escrow SiswaBantu
              </h3>
              <p className="text-[11px] text-slate-500 font-medium">
                ToyyibPay / Billplz Sandbox Gateway (FR-4.1)
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 flex items-center justify-center text-sm font-bold"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Ringkasan Bayaran */}
        <div className="p-3.5 bg-slate-50 rounded-2xl border border-slate-200 flex justify-between items-center">
          <div>
            <span className="text-[11px] text-slate-500 block">Jumlah Perlu Dibayar:</span>
            <span className="text-xl font-extrabold text-indigo-700">
              {formatRM(order.total_amount)}
            </span>
          </div>
          <div className="text-right">
            <span className="px-2.5 py-1 rounded-full bg-emerald-100 text-emerald-800 text-[10px] font-extrabold flex items-center gap-1">
              <ShieldCheck className="w-3 h-3 text-emerald-600" /> Jaminan Escrow
            </span>
            <span className="text-[10px] text-slate-400 mt-1 block">Dana disimpan sehingga siap</span>
          </div>
        </div>

        {/* Step 1: Pilih Bank */}
        {step === 'select_bank' && (
          <div className="space-y-3">
            <label className="text-xs font-bold text-slate-700 block">
              Pilih Bank Perbankan Dalam Talian (FPX):
            </label>

            <div className="grid grid-cols-2 gap-2">
              {BANKS.map((bank) => (
                <button
                  key={bank.id}
                  type="button"
                  onClick={() => setSelectedBank(bank.id)}
                  className={`p-2.5 rounded-xl border text-left flex items-center gap-2 transition-all ${
                    selectedBank === bank.id
                      ? 'border-indigo-600 bg-indigo-50/50 ring-2 ring-indigo-500/20'
                      : 'border-slate-200 hover:bg-slate-50'
                  }`}
                >
                  <span className="text-lg">{bank.logo}</span>
                  <span className="text-xs font-bold text-slate-800 line-clamp-1">{bank.name}</span>
                </button>
              ))}
            </div>

            <div className="pt-2">
              <button
                onClick={() => setStep('bank_login')}
                className="w-full py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-extrabold text-xs shadow-md shadow-indigo-500/20 flex items-center justify-center gap-2 active:scale-95 transition-all"
              >
                <span>Teruskan ke Halaman Simulasi Bank</span>
                <ArrowRight className="w-4 h-4" />
              </button>
            </div>
          </div>
        )}

        {/* Step 2: Halaman Simulasi Bank */}
        {step === 'bank_login' && (
          <div className="space-y-3 bg-amber-50/50 p-4 rounded-2xl border border-amber-200">
            <div className="flex items-center gap-2 text-xs font-bold text-amber-900 pb-2 border-b border-amber-200">
              <Lock className="w-3.5 h-3.5 text-amber-700" />
              <span>Simulasi FPX Sandbox (Persekitaran Ujian)</span>
            </div>

            <div>
              <label className="text-[11px] font-bold text-slate-600 block mb-1">ID Pengguna Bank</label>
              <input
                type="text"
                value={bankUsername}
                onChange={(e) => setBankUsername(e.target.value)}
                className="w-full text-xs bg-white border border-slate-200 rounded-lg p-2 font-mono"
              />
            </div>

            <div>
              <label className="text-[11px] font-bold text-slate-600 block mb-1">Kata Laluan Rahsia</label>
              <input
                type="password"
                value={bankPassword}
                onChange={(e) => setBankPassword(e.target.value)}
                className="w-full text-xs bg-white border border-slate-200 rounded-lg p-2 font-mono"
              />
            </div>

            <button
              onClick={handleSimulatePayment}
              className="w-full mt-2 py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold text-xs shadow-md transition-all flex items-center justify-center gap-2"
            >
              <CheckCircle2 className="w-4 h-4" />
              <span>Sahkan Pembayaran FPX Sandbox ({formatRM(order.total_amount)})</span>
            </button>
          </div>
        )}

        {/* Step 3: Memproses Transaksi */}
        {step === 'processing' && (
          <div className="py-8 text-center space-y-3">
            <div className="w-12 h-12 border-4 border-indigo-600 border-t-transparent rounded-full animate-spin mx-auto" />
            <h4 className="font-extrabold text-slate-800 text-sm">Menghubungi Gerbang ToyyibPay/Billplz...</h4>
            <p className="text-xs text-slate-500">Mengesahkan Webhook Callback Signature & Memegang Dana di Escrow...</p>
          </div>
        )}

        {/* Step 4: Berjaya */}
        {step === 'success' && (
          <div className="py-6 text-center space-y-3">
            <div className="w-12 h-12 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center mx-auto">
              <CheckCircle2 className="w-7 h-7" />
            </div>
            <h4 className="font-extrabold text-slate-900 text-sm">Bayaran Berjaya Diterima!</h4>
            <p className="text-xs text-emerald-700 font-medium">
              Dana {formatRM(order.total_amount)} kini selamat disimpan di <strong>Akaun Escrow SiswaBantu</strong>. Status pesanan dikemas kini ke <strong>MENUNGGU_TERIMA</strong>.
            </p>
          </div>
        )}

      </div>
    </div>
  );
}

