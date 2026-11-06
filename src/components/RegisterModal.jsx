import React, { useState } from 'react';
import { 
  UserPlus, 
  Mail, 
  Phone, 
  Lock, 
  User, 
  AlertCircle, 
  CheckCircle2, 
  X, 
  KeyRound,
  ShieldCheck
} from 'lucide-react';
import { validateEduEmail } from '../utils/security';
import { ALL_IPTA } from '../data/iptaData';

export default function RegisterModal({ isOpen, onClose, onRegisterSuccess }) {
  const [step, setStep] = useState('form'); // form | otp | success
  const [fullName, setFullName] = useState('Aiman Hakimi');
  const [email, setEmail] = useState('20261234@student.uitm.edu.my');
  const [phone, setPhone] = useState('+6011-23456789');
  const [university, setUniversity] = useState('Universiti Teknologi MARA (UiTM)');
  const [password, setPassword] = useState('Siswa@2026');
  const [otp, setOtp] = useState(['5', '2', '8', '9', '1', '4']);
  const [errorMessage, setErrorMessage] = useState(null);

  if (!isOpen) return null;

  const handleSubmitForm = (e) => {
    e.preventDefault();
    setErrorMessage(null);

    // FR-1.1 & TC-AUTH-02: Validasi .edu.my
    if (!validateEduEmail(email)) {
      setErrorMessage('Pendaftaran hanya dibuka untuk e-mel rasmi institusi (.edu.my). Sila gunakan e-mel siswa/siswi universiti anda.');
      return;
    }

    // Jika sah (TC-AUTH-01), beralih ke skrin OTP
    setStep('otp');
  };

  const handleVerifyOtp = (e) => {
    e.preventDefault();
    const enteredOtp = otp.join('');
    if (enteredOtp.length === 6) {
      setStep('success');
      setTimeout(() => {
        onRegisterSuccess({
          user_id: `usr-${Date.now()}`,
          full_name: fullName,
          edu_email: email,
          phone_no: phone,
          university_name: university,
          matric_no: '2026' + Math.floor(100000 + Math.random() * 900000),
          kyc_status: 'Verified',
          wallet_balance: 0.00,
          escrow_balance: 0.00,
          rating_avg: 5.0,
          rating_count: 0,
          active_role: 'pemohon',
          avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
          college: 'Kolej Kediaman',
          bio: `Mahasiswa ${university}`,
          is_active_now: true,
        });
        onClose();
      }, 1500);
    }
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/65 backdrop-blur-sm flex items-center justify-center p-4 animate-fadeIn">
      <div className="bg-white rounded-3xl max-w-md w-full p-5 sm:p-6 shadow-2xl border border-slate-200 space-y-4">
        
        {/* Header */}
        <div className="flex justify-between items-center pb-2 border-b border-slate-100">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-xl bg-selangor-red/10 text-selangor-red flex items-center justify-center">
              <UserPlus className="w-4 h-4" />
            </div>
            <div>
              <h3 className="font-extrabold text-sm sm:text-base text-slate-900">
                Pendaftaran SiswaBantu (FR-1.1)
              </h3>
              <p className="text-[11px] text-slate-500 font-medium">
                Komuniti Kampus 21 IPTA Seluruh Malaysia
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

        {/* Step 1: Borang Maklumat */}
        {step === 'form' && (
          <form onSubmit={handleSubmitForm} className="space-y-3">
            {errorMessage && (
              <div className="bg-red-50 border border-red-200 rounded-xl p-3 text-xs text-red-700 font-semibold flex items-start gap-2 animate-shake">
                <AlertCircle className="w-4 h-4 shrink-0 text-selangor-red mt-0.5" />
                <span>{errorMessage}</span>
              </div>
            )}

            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">Nama Penuh *</label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                <input
                  type="text"
                  required
                  value={fullName}
                  onChange={(e) => setFullName(e.target.value)}
                  className="w-full pl-9 pr-3 py-2 text-xs bg-slate-50 border border-slate-200 rounded-xl font-medium outline-none focus:ring-2 focus:ring-selangor-red"
                />
              </div>
            </div>

            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">
                E-mel Rasmi Universiti (.edu.my) *
              </label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                <input
                  type="email"
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="cth: 20261234@student.uitm.edu.my"
                  className="w-full pl-9 pr-3 py-2 text-xs bg-slate-50 border border-slate-200 rounded-xl font-medium outline-none focus:ring-2 focus:ring-selangor-red"
                />
              </div>
              <span className="text-[10px] text-slate-500 mt-0.5 block">
                * Wajib berakhiran .edu.my bagi menjamin keselamatan komuniti pelajar.
              </span>
            </div>

            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">Pilihan Universiti / IPTA *</label>
              <select
                value={university}
                onChange={(e) => setUniversity(e.target.value)}
                className="w-full px-3 py-2 text-xs bg-slate-50 border border-slate-200 rounded-xl font-medium outline-none focus:ring-2 focus:ring-selangor-red"
              >
                {ALL_IPTA.map((ipta) => (
                  <option key={ipta.code} value={`${ipta.fullName} (${ipta.code})`}>
                    {ipta.code} - {ipta.fullName} ({ipta.state})
                  </option>
                ))}
              </select>
            </div>

            <div className="grid grid-cols-2 gap-2">
              <div>
                <label className="text-xs font-bold text-slate-700 block mb-1">No. Telefon *</label>
                <input
                  type="tel"
                  required
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  className="w-full px-3 py-2 text-xs bg-slate-50 border border-slate-200 rounded-xl font-medium outline-none focus:ring-2 focus:ring-selangor-red"
                />
              </div>
              <div>
                <label className="text-xs font-bold text-slate-700 block mb-1">Kata Laluan *</label>
                <input
                  type="password"
                  required
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="w-full px-3 py-2 text-xs bg-slate-50 border border-slate-200 rounded-xl font-medium outline-none focus:ring-2 focus:ring-selangor-red"
                />
              </div>
            </div>

            {/* Quick Test Fillers */}
            <div className="flex flex-wrap gap-1.5 pt-1 text-[10px]">
              <button
                type="button"
                onClick={() => {
                  setFullName('Muhammad Haziq');
                  setEmail('m20261024@siswa.upsi.edu.my');
                  setUniversity('Universiti Pendidikan Sultan Idris (UPSI)');
                }}
                className="px-2 py-1 rounded bg-amber-100 text-amber-900 font-bold hover:bg-amber-200"
              >
                Isi UPSI (.edu.my)
              </button>
              <button
                type="button"
                onClick={() => {
                  setFullName('Aiman Hakimi');
                  setEmail('20261234@student.uitm.edu.my');
                  setUniversity('Universiti Teknologi MARA (UiTM)');
                }}
                className="px-2 py-1 rounded bg-emerald-100 text-emerald-800 font-bold hover:bg-emerald-200"
              >
                Isi UiTM (.edu.my)
              </button>
              <button
                type="button"
                onClick={() => setEmail('aiman.hakimi@gmail.com')}
                className="px-2 py-1 rounded bg-red-100 text-red-800 font-bold hover:bg-red-200"
              >
                Uji Sekat @gmail (TC-AUTH-02)
              </button>
            </div>

            <div className="pt-2">
              <button
                type="submit"
                className="w-full py-3 rounded-xl bg-selangor-red hover:bg-selangor-red-dark text-white font-extrabold text-xs shadow-md shadow-selangor-red/20 active:scale-95 transition-all"
              >
                Hantar & Terima Kod OTP 6-Digit
              </button>
            </div>
          </form>
        )}

        {/* Step 2: Masukkan Kod OTP 6 Digit */}
        {step === 'otp' && (
          <form onSubmit={handleVerifyOtp} className="space-y-4 text-center">
            <div className="w-12 h-12 rounded-full bg-selangor-red/10 text-selangor-red flex items-center justify-center mx-auto">
              <KeyRound className="w-6 h-6" />
            </div>

            <div>
              <h4 className="font-extrabold text-slate-900 text-sm">
                Sahkan Kod OTP E-mel Pelajar
              </h4>
              <p className="text-xs text-slate-500 mt-1">
                Kod keselamatan 6-digit telah dihantar ke <strong>{email}</strong>
              </p>
            </div>

            {/* 6 Digit Input Boxes */}
            <div className="flex justify-center gap-2 py-2">
              {otp.map((digit, idx) => (
                <input
                  key={idx}
                  type="text"
                  maxLength={1}
                  value={digit}
                  onChange={(e) => {
                    const nextOtp = [...otp];
                    nextOtp[idx] = e.target.value;
                    setOtp(nextOtp);
                  }}
                  className="w-11 h-12 text-center text-lg font-extrabold bg-slate-50 border-2 border-slate-200 rounded-xl focus:border-selangor-red focus:bg-white outline-none"
                />
              ))}
            </div>

            <p className="text-[11px] text-slate-400">
              Tidak menerima kod? <span className="text-selangor-red font-bold cursor-pointer">Hantar semula (54s)</span>
            </p>

            <button
              type="submit"
              className="w-full py-3 rounded-xl bg-selangor-red hover:bg-selangor-red-dark text-white font-extrabold text-xs shadow-md transition-all"
            >
              Sahkan OTP & Aktifkan Akaun Asas
            </button>
          </form>
        )}

        {/* Step 3: Berjaya */}
        {step === 'success' && (
          <div className="py-6 text-center space-y-3 animate-fadeIn">
            <div className="w-12 h-12 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center mx-auto">
              <CheckCircle2 className="w-7 h-7" />
            </div>
            <h4 className="font-extrabold text-slate-900 text-sm">
              Pendaftaran Akaun Mahasiswa Berjaya!
            </h4>
            <p className="text-xs text-slate-600">
              Akaun anda diaktifkan dengan status Asas (Pemohon Bantu). Anda boleh membuat pengesahan e-KYC pada bila-bila masa untuk menjadi Penyedia Bantu.
            </p>
          </div>
        )}

      </div>
    </div>
  );
}

