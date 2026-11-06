import React from 'react';
import { Store, Flame, ClipboardList, Wallet, User, PlusCircle } from 'lucide-react';

export default function BottomNav({ activeTab, setActiveTab, activeRole, ordersCount, sosCount, onAddService }) {
  const isPenyedia = activeRole === 'penyedia';

  return (
    <nav className="absolute bottom-0 inset-x-0 bg-white/95 backdrop-blur-md border-t border-slate-200/90 px-3 py-2 z-40 shadow-lg">
      <div className="flex items-center justify-around max-w-md mx-auto">
        
        {/* Katalog / Servis */}
        <button
          onClick={() => setActiveTab('explore')}
          className={`flex flex-col items-center justify-center flex-1 py-1 transition-all ${
            activeTab === 'explore' 
              ? 'text-selangor-red font-bold' 
              : 'text-slate-500 hover:text-slate-800'
          }`}
        >
          <Store className={`w-5 h-5 ${activeTab === 'explore' ? 'stroke-[2.5]' : ''}`} />
          <span className="text-[10px] mt-0.5">{isPenyedia ? 'Katalog' : 'Cari Servis'}</span>
        </button>

        {/* Bantu SOS */}
        <button
          onClick={() => setActiveTab('sos')}
          className={`relative flex flex-col items-center justify-center flex-1 py-1 transition-all ${
            activeTab === 'sos' 
              ? 'text-amber-500 font-bold' 
              : 'text-slate-500 hover:text-slate-800'
          }`}
        >
          <div className="relative">
            <Flame className={`w-5 h-5 ${activeTab === 'sos' ? 'stroke-[2.5] fill-amber-500 text-amber-500' : ''}`} />
            {sosCount > 0 && (
              <span className="absolute -top-1 -right-2 px-1 min-w-[14px] h-[14px] bg-selangor-red text-white text-[9px] font-extrabold rounded-full flex items-center justify-center animate-pulse">
                {sosCount}
              </span>
            )}
          </div>
          <span className="text-[10px] mt-0.5">Bantu SOS</span>
        </button>

        {/* Action Button for Penyedia: Tambah Servis */}
        {isPenyedia && (
          <button
            onClick={onAddService}
            className="flex flex-col items-center justify-center -mt-5 mx-1"
            title="Tambah Servis Baharu"
          >
            <div className="w-12 h-12 rounded-full bg-gradient-to-tr from-selangor-red to-selangor-amber text-white flex items-center justify-center shadow-lg shadow-selangor-red/30 hover:scale-105 active:scale-95 transition-all">
              <PlusCircle className="w-6 h-6" />
            </div>
            <span className="text-[10px] font-bold text-slate-700 mt-0.5">Servis</span>
          </button>
        )}

        {/* Pesanan / Tugasan */}
        <button
          onClick={() => setActiveTab('orders')}
          className={`relative flex flex-col items-center justify-center flex-1 py-1 transition-all ${
            activeTab === 'orders' 
              ? 'text-selangor-red font-bold' 
              : 'text-slate-500 hover:text-slate-800'
          }`}
        >
          <div className="relative">
            <ClipboardList className={`w-5 h-5 ${activeTab === 'orders' ? 'stroke-[2.5]' : ''}`} />
            {ordersCount > 0 && (
              <span className="absolute -top-1 -right-2 px-1 min-w-[14px] h-[14px] bg-selangor-amber text-slate-900 text-[9px] font-extrabold rounded-full flex items-center justify-center">
                {ordersCount}
              </span>
            )}
          </div>
          <span className="text-[10px] mt-0.5">{isPenyedia ? 'Tugasan' : 'Pesanan'}</span>
        </button>

        {/* Dompet */}
        <button
          onClick={() => setActiveTab('wallet')}
          className={`flex flex-col items-center justify-center flex-1 py-1 transition-all ${
            activeTab === 'wallet' 
              ? 'text-selangor-red font-bold' 
              : 'text-slate-500 hover:text-slate-800'
          }`}
        >
          <Wallet className={`w-5 h-5 ${activeTab === 'wallet' ? 'stroke-[2.5]' : ''}`} />
          <span className="text-[10px] mt-0.5">Dompet</span>
        </button>

        {/* Profil */}
        <button
          onClick={() => setActiveTab('profile')}
          className={`flex flex-col items-center justify-center flex-1 py-1 transition-all ${
            activeTab === 'profile' 
              ? 'text-selangor-red font-bold' 
              : 'text-slate-500 hover:text-slate-800'
          }`}
        >
          <User className={`w-5 h-5 ${activeTab === 'profile' ? 'stroke-[2.5]' : ''}`} />
          <span className="text-[10px] mt-0.5">Profil</span>
        </button>

      </div>
    </nav>
  );
}

