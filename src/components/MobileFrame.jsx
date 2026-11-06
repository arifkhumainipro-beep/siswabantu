import React from 'react';
import { Wifi, BatteryMedium, Signal } from 'lucide-react';

export default function MobileFrame({ children, activeTab, setActiveTab, ordersCount, sosCount }) {
  // Waktu semasa
  const currentTime = new Date().toLocaleTimeString('ms-MY', { hour: '2-digit', minute: '2-digit' });

  return (
    <div className="flex justify-center items-center py-4 px-2 sm:px-4">
      <div className="relative w-full max-w-[430px] h-[860px] bg-slate-900 rounded-[48px] p-3 shadow-2xl ring-1 ring-slate-800/80 shadow-black/40 flex flex-col overflow-hidden">
        
        {/* Device Outer Edge Details */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-40 h-5 bg-slate-900 rounded-b-2xl z-50 flex items-center justify-center">
          <div className="w-16 h-4 bg-black rounded-full flex items-center justify-end px-2">
            <div className="w-2.5 h-2.5 bg-slate-800 rounded-full" />
          </div>
        </div>

        {/* Screen Bezel & Container */}
        <div className="relative w-full h-full bg-slate-50 rounded-[38px] overflow-hidden flex flex-col border border-slate-200/60 shadow-inner">
          
          {/* Status Bar */}
          <div className="h-9 px-6 pt-1 flex items-center justify-between text-xs font-semibold text-slate-800 z-40 bg-white/80 backdrop-blur-sm select-none">
            <span className="text-[13px] font-bold tracking-tight">{currentTime}</span>
            <div className="flex items-center gap-1.5 text-slate-700">
              <Signal className="w-3.5 h-3.5" />
              <Wifi className="w-3.5 h-3.5" />
              <div className="flex items-center gap-0.5">
                <span className="text-[11px] font-bold">98%</span>
                <BatteryMedium className="w-4 h-4 fill-slate-700" />
              </div>
            </div>
          </div>

          {/* Main App Content Area */}
          <div className="flex-1 overflow-y-auto pb-20 relative bg-slate-50">
            {children}
          </div>

          {/* Bottom Bar Indicator (iOS style bar) */}
          <div className="absolute bottom-1 left-1/2 -translate-x-1/2 w-32 h-1 bg-slate-400/60 rounded-full z-50 pointer-events-none" />
        </div>
      </div>
    </div>
  );
}

