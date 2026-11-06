import React from 'react';
import { 
  ShieldCheck, 
  Wallet, 
  Store, 
  Flame, 
  ClipboardList, 
  User, 
  LogOut, 
  CheckCircle2, 
  AlertCircle,
  Sparkles,
  SlidersHorizontal,
  Zap,
  PlusCircle
} from 'lucide-react';
import { formatRM } from '../utils/security';

export default function Header({ 
  currentUser, 
  authRole, 
  onToggleRole, 
  activeTab, 
  setActiveTab, 
  onLogout,
  onOpenWallet, 
  onOpenEkyc,
  onAddService,
  ordersCount,
  sosCount
}) {
  const isPenyedia = currentUser?.active_role === 'penyedia';
  const isAdmin = authRole === 'admin';

  return (
    <header className="sticky top-0 z-40 bg-white/95 backdrop-blur-md border-b border-slate-200 shadow-sm transition-all">
      {/* Jalur Rasmi SiswaBantu (Tema Merah & Kuning / Emas) */}
      <div className="w-full bg-gradient-to-r from-[#881337] via-[#C8102E] via-[#DC2626] to-[#FFCC00] text-white py-1 px-4 text-[10px] font-extrabold flex items-center justify-between shadow-xs">
        <div className="flex items-center gap-2">
          <div className="w-4 h-4 rounded-full bg-gradient-to-tr from-[#FFCC00] to-[#F59E0B] flex items-center justify-center text-[#7F1D1D] shadow-xs">
            <Sparkles className="w-2.5 h-2.5" />
          </div>
          <span className="tracking-wider">SISWABANTU MALAYSIA</span>
          <span className="px-1.5 py-0.5 rounded-md bg-[#FFCC00] text-[#7F1D1D] font-black text-[9px] uppercase tracking-wide">
            21 IPTA RESMI
          </span>
        </div>
        <div className="hidden sm:flex items-center gap-2 text-white/95 text-[10px] font-bold">
          <span>🛡️ 100% Perlindungan Escrow Terjamin</span>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16 gap-3">
          
          {/* Logo & Brand */}
          <div className="flex items-center gap-3">
            <div className="relative">
              <img 
                src="/logo.png" 
                alt="SiswaBantu Logo" 
                className="w-10 h-10 rounded-xl object-cover shadow-md shadow-red-600/30 ring-1 ring-red-500/20"
              />
              <div className="absolute -top-1 -right-1 w-3.5 h-3.5 bg-[#FFCC00] rounded-full border-2 border-white animate-pulse" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <span className="text-xl font-extrabold bg-gradient-to-r from-[#991B1B] via-[#C8102E] to-[#D97706] bg-clip-text text-transparent tracking-tight">
                  SiswaBantu
                </span>
                <span className="text-[10px] uppercase font-bold tracking-wider px-2 py-0.5 rounded-full bg-red-50 text-selangor-red border border-red-200">
                  {isAdmin ? 'ADMIN PORTAL' : '21 IPTA PRO'}
                </span>
              </div>
              <p className="text-[11px] text-slate-500 hidden sm:block font-medium">
                {isAdmin ? 'Pusat Kawalan & Timbang Tara Sistem' : 'Ringankan Beban, Tambah Pendapatan'}
              </p>
            </div>
          </div>

          {/* Desktop Web Navigation Tabs for Students */}
          {!isAdmin && (
            <nav className="hidden md:flex items-center gap-1 bg-slate-100/90 p-1 rounded-2xl border border-slate-200/80 text-xs font-bold text-slate-600">
              <button
                onClick={() => setActiveTab('explore')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl transition-all ${
                  activeTab === 'explore'
                    ? 'bg-white text-indigo-600 shadow-sm'
                    : 'hover:text-slate-900'
                }`}
              >
                <Store className="w-4 h-4" />
                <span>Katalog Servis</span>
              </button>

              <button
                onClick={() => setActiveTab('sos')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl transition-all relative ${
                  activeTab === 'sos'
                    ? 'bg-white text-amber-600 shadow-sm'
                    : 'hover:text-slate-900'
                }`}
              >
                <Flame className={`w-4 h-4 ${activeTab === 'sos' ? 'fill-amber-500 text-amber-500' : ''}`} />
                <span>Bantu SOS</span>
                {sosCount > 0 && (
                  <span className="px-1.5 py-0.2 min-w-[16px] h-4 bg-rose-500 text-white text-[9px] font-extrabold rounded-full flex items-center justify-center">
                    {sosCount}
                  </span>
                )}
              </button>

              <button
                onClick={() => setActiveTab('orders')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl transition-all relative ${
                  activeTab === 'orders'
                    ? 'bg-white text-indigo-600 shadow-sm'
                    : 'hover:text-slate-900'
                }`}
              >
                <ClipboardList className="w-4 h-4" />
                <span>Pesanan & Escrow</span>
                {ordersCount > 0 && (
                  <span className="px-1.5 py-0.2 min-w-[16px] h-4 bg-cyan-600 text-white text-[9px] font-extrabold rounded-full flex items-center justify-center">
                    {ordersCount}
                  </span>
                )}
              </button>

              <button
                onClick={() => setActiveTab('wallet')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl transition-all ${
                  activeTab === 'wallet'
                    ? 'bg-white text-emerald-700 shadow-sm'
                    : 'hover:text-slate-900'
                }`}
              >
                <Wallet className="w-4 h-4" />
                <span>Dompet</span>
              </button>

              <button
                onClick={() => setActiveTab('profile')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl transition-all ${
                  activeTab === 'profile'
                    ? 'bg-white text-indigo-600 shadow-sm'
                    : 'hover:text-slate-900'
                }`}
              >
                <User className="w-4 h-4" />
                <span>Profil</span>
              </button>
            </nav>
          )}

          {/* Right Action Bar */}
          <div className="flex items-center gap-2 sm:gap-3">
            
            {!isAdmin ? (
              <>
                {/* Butang Tawar Servis Sentiasa Tersedia untuk Semua Siswa */}
                {onAddService && (
                  <button
                    onClick={onAddService}
                    className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-gradient-to-r from-selangor-red to-selangor-dark hover:brightness-110 text-white text-xs font-extrabold shadow-sm shadow-selangor-red/25 active:scale-95 transition-all"
                  >
                    <PlusCircle className="w-3.5 h-3.5" />
                    <span>+ Tawar Servis</span>
                  </button>
                )}

                {/* Wallet Balance Pill */}
                <button
                  onClick={onOpenWallet}
                  className="flex items-center gap-1.5 px-2.5 sm:px-3 py-1.5 rounded-xl bg-slate-50 hover:bg-slate-100 border border-slate-200 text-xs font-bold text-slate-800 transition-all"
                >
                  <div className="w-6 h-6 rounded-lg bg-emerald-100 text-emerald-700 flex items-center justify-center">
                    <Wallet className="w-3.5 h-3.5" />
                  </div>
                  <div className="text-left hidden sm:block">
                    <div className="text-[10px] text-slate-500 uppercase leading-none">Dompet</div>
                    <div className="text-emerald-700 font-extrabold text-xs">{formatRM(currentUser?.wallet_balance || 0)}</div>
                  </div>
                </button>

                {/* User Info & Avatar */}
                <div 
                  onClick={() => setActiveTab('profile')}
                  className="flex items-center gap-2 cursor-pointer p-1 rounded-xl hover:bg-slate-50"
                  title="Buka Profil"
                >
                  <img
                    src={currentUser?.avatar}
                    alt={currentUser?.full_name}
                    className="w-8 h-8 rounded-full ring-2 ring-indigo-500/30 object-cover"
                  />
                  <div className="hidden lg:block text-left text-xs leading-tight">
                    <span className="font-extrabold text-slate-900 block truncate max-w-[120px]">
                      {currentUser?.full_name}
                    </span>
                    <span className="text-[10px] text-slate-500 font-mono">
                      {currentUser?.matric_no}
                    </span>
                  </div>
                </div>
              </>
            ) : (
              /* Admin Info Pill */
              <div className="flex items-center gap-2 px-3 py-1.5 rounded-xl bg-slate-900 text-white text-xs font-bold border border-slate-800">
                <SlidersHorizontal className="w-4 h-4 text-cyan-400" />
                <span>Pusat Kawalan Pentadbir</span>
              </div>
            )}

            {/* Log Keluar Button (Logout) */}
            <button
              onClick={onLogout}
              className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl border border-slate-200 text-slate-600 hover:text-rose-600 hover:bg-rose-50 hover:border-rose-200 text-xs font-extrabold transition-all"
              title="Log keluar ke halaman utama"
            >
              <LogOut className="w-3.5 h-3.5" />
              <span className="hidden sm:inline">Log Keluar</span>
            </button>

          </div>

        </div>
      </div>
    </header>
  );
}
