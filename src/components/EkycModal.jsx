import React, { useState } from 'react';
import { 
  ShieldCheck, 
  Camera, 
  Upload, 
  CheckCircle2, 
  X, 
  Sparkles, 
  ScanLine, 
  AlertCircle,
  FileText
} from 'lucide-react';

export default function EkycModal({ currentUser, onClose, onVerified }) {
  const [step, setStep] = useState('upload'); // upload | scanning | verified
  const [matricImg, setMatricImg] = useState('https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=600&q=80');
  const [selfieImg, setSelfieImg] = useState(currentUser?.avatar || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80');
  const [ocrData, setOcrData] = useState(null);

  const startOcrScan = () => {
    setStep('scanning');
    setTimeout(() => {
      // Hasil OCR diekstrak automatik (Google Cloud Vision OCR Mock)
      const extracted = {
        matric_no: currentUser?.matric_no || '2026123456',
        extracted_name: currentUser?.full_name || 'Aiman Hakimi',
        university: currentUser?.university_name || 'UiTM Shah Alam',
        confidence: '99.4%',
        match_status: 'PADAN (100% MATCH)'
      };
      setOcrData(extracted);
      setStep('verified');
      if (onVerified) onVerified(extracted);
    }, 1800);
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/65 backdrop-blur-sm flex items-center justify-center p-4 animate-fadeIn">
      <div className="bg-white rounded-3xl max-w-md w-full p-5 sm:p-6 shadow-2xl border border-slate-200 space-y-4">
        
        {/* Header */}
        <div className="flex justify-between items-center pb-2 border-b border-slate-100">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center">
              <ShieldCheck className="w-4 h-4" />
            </div>
            <div>
              <h3 className="font-extrabold text-sm sm:text-base text-slate-900">
                Pengesahan e-KYC Kad Matrik (FR-1.2)
              </h3>
              <p className="text-[11px] text-slate-500 font-medium">
                Pengecaman Teks Optik (OCR) Google Cloud Vision
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

        {/* Step 1: Upload Matrix Card & Live Selfie */}
        {step === 'upload' && (
          <div className="space-y-3.5">
            <div className="bg-amber-50 p-3 rounded-xl border border-amber-200 text-xs text-amber-900">
              <p className="leading-relaxed">
                Untuk menjamin keselamatan komuniti kampus daripada scammer, setiap Penyedia Bantu wajib mengesahkan <strong>Kad Matrik Pelajar</strong> dan <strong>Swafoto Langsung (Live Selfie)</strong>.
              </p>
            </div>

            {/* Kad Matrik Dropzone */}
            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">
                1. Gambar Hadapan Kad Matrik Pelajar
              </label>
              <div className="relative border-2 border-dashed border-slate-300 hover:border-indigo-600 rounded-2xl p-3 bg-slate-50 text-center transition-all">
                <img
                  src={matricImg}
                  alt="Kad Matrik"
                  className="w-full h-32 object-cover rounded-xl shadow-sm"
                />
                <span className="absolute bottom-5 right-5 px-2.5 py-1 rounded-full bg-black/70 text-white text-[10px] font-bold">
                  kad_matrik_pelajar.jpg (1.5MB)
                </span>
              </div>
            </div>

            {/* Selfie Swafoto Dropzone */}
            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">
                2. Swafoto Langsung (Facial Liveness)
              </label>
              <div className="flex items-center gap-3 p-3 bg-slate-50 border border-slate-200 rounded-2xl">
                <img
                  src={selfieImg}
                  alt="Swafoto"
                  className="w-14 h-14 rounded-full object-cover ring-2 ring-indigo-500/30"
                />
                <div className="flex-1">
                  <span className="text-xs font-bold text-slate-800 block">Kamera Langsung Diaktifkan</span>
                  <span className="text-[11px] text-emerald-600 flex items-center gap-1 font-semibold">
                    <CheckCircle2 className="w-3.5 h-3.5" /> Liveness Passed (Tiada Topeng/Foto Statik)
                  </span>
                </div>
              </div>
            </div>

            <div className="pt-2">
              <button
                onClick={startOcrScan}
                className="w-full py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-extrabold text-xs shadow-md shadow-indigo-500/20 flex items-center justify-center gap-2 active:scale-95 transition-all"
              >
                <ScanLine className="w-4 h-4 animate-pulse" />
                <span>Imbas Kad Matrik & Sahkan Identiti (TC-AUTH-03)</span>
              </button>
            </div>
          </div>
        )}

        {/* Step 2: Animasi Pengecaman OCR */}
        {step === 'scanning' && (
          <div className="py-10 text-center space-y-4">
            <div className="relative w-28 h-20 mx-auto border-2 border-indigo-600 rounded-xl overflow-hidden bg-slate-900 flex items-center justify-center">
              <div className="absolute inset-x-0 h-1 bg-cyan-400 shadow-lg shadow-cyan-400 animate-bounce" />
              <FileText className="w-8 h-8 text-white/50" />
            </div>
            <div>
              <h4 className="font-extrabold text-slate-900 text-sm">
                Enjin OCR Google Cloud Vision Sedang Memproses...
              </h4>
              <p className="text-xs text-slate-500 mt-1">
                Mengekstrak Nombor Matrik, Nama, dan Memadankan dengan Pangkalan Data IPTA...
              </p>
            </div>
          </div>
        )}

        {/* Step 3: Pengesahan Berjaya */}
        {step === 'verified' && ocrData && (
          <div className="space-y-3.5 animate-fadeIn">
            <div className="bg-emerald-50 border border-emerald-200 rounded-2xl p-4 text-center space-y-2">
              <div className="w-12 h-12 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center mx-auto">
                <CheckCircle2 className="w-7 h-7" />
              </div>
              <h4 className="font-extrabold text-emerald-900 text-sm">
                e-KYC Disahkan Sepenuhnya!
              </h4>
              <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-200 text-emerald-900 inline-block">
                Status: Verified (Penyedia Sah)
              </span>
            </div>

            {/* Hasil Ekstraksi OCR */}
            <div className="bg-slate-50 rounded-2xl p-3.5 border border-slate-200 text-xs space-y-1.5">
              <div className="flex justify-between text-slate-600">
                <span>Nama Diekstrak:</span>
                <strong className="text-slate-900">{ocrData.extracted_name}</strong>
              </div>
              <div className="flex justify-between text-slate-600">
                <span>Nombor Matrik:</span>
                <strong className="font-mono text-indigo-700">{ocrData.matric_no}</strong>
              </div>
              <div className="flex justify-between text-slate-600">
                <span>Institusi / Universiti:</span>
                <strong className="text-slate-800">{ocrData.university}</strong>
              </div>
              <div className="flex justify-between text-slate-600 pt-1 border-t border-slate-200">
                <span>Keyakinan OCR:</span>
                <strong className="text-emerald-600">{ocrData.confidence}</strong>
              </div>
            </div>

            <button
              onClick={onClose}
              className="w-full py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-extrabold text-xs shadow-md shadow-indigo-500/20 transition-all"
            >
              Kembali ke Aplikasi (Akses Buka Kedai Aktif)
            </button>
          </div>
        )}

      </div>
    </div>
  );
}

