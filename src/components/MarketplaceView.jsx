import React, { useState, useMemo } from 'react';
import { 
  Search, 
  SlidersHorizontal, 
  Star, 
  Clock, 
  CheckCircle2, 
  Sparkles, 
  ShieldCheck, 
  MapPin, 
  GraduationCap, 
  ArrowRight,
  Filter,
  X,
  Zap,
  Bike,
  Laptop,
  Palette,
  BookOpen,
  Shirt,
  Bookmark,
  Bell,
  ArrowUpRight,
  Wrench
} from 'lucide-react';
import { CATEGORIES } from '../data/mockData';
import { ALL_IPTA } from '../data/iptaData';
import IPTALogoBadge from './IPTALogoBadge';
import { formatRM } from '../utils/security';

export default function MarketplaceView({ 
  services, 
  onSelectService, 
  onBookService, 
  onStartChatWithProvider,
  activeRole,
  currentUser,
  onToggleRole,
  onAddService
}) {
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [selectedUniv, setSelectedUniv] = useState('all');
  const [maxPrice, setMaxPrice] = useState(150);
  const [onlyHighRating, setOnlyHighRating] = useState(false);
  const [showFilters, setShowFilters] = useState(false);
  const [bookmarkedIds, setBookmarkedIds] = useState(new Set(['srv-1', 'srv-3']));
  const [showNotificationModal, setShowNotificationModal] = useState(false);

  const toggleBookmark = (id, e) => {
    e.stopPropagation();
    setBookmarkedIds(prev => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  // Search & Filter Logic
  const filteredServices = useMemo(() => {
    return services.filter((srv) => {
      const matchesSearch = 
        searchTerm === '' ||
        srv.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
        srv.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
        srv.category_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        srv.provider_name.toLowerCase().includes(searchTerm.toLowerCase());

      const matchesCat = selectedCategory === 'all' || srv.category === selectedCategory;
      const matchesUniv = 
        selectedUniv === 'all' || 
        (selectedUniv === 'selangor'
          ? (srv.university.toLowerCase().includes('selangor') || srv.university.toLowerCase().includes('unisel') || srv.university.toLowerCase().includes('uitm') || srv.university.toLowerCase().includes('ukm') || srv.university.toLowerCase().includes('upm'))
          : srv.university.toLowerCase().includes(selectedUniv.toLowerCase()));
      const matchesPrice = srv.price <= maxPrice;
      const matchesRating = !onlyHighRating || srv.rating >= 4.0;

      return matchesSearch && matchesCat && matchesUniv && matchesPrice && matchesRating;
    });
  }, [services, searchTerm, selectedCategory, selectedUniv, maxPrice, onlyHighRating]);

  // Featured / Popular Services for Carousel
  const popularServices = useMemo(() => {
    return services.slice(0, 5);
  }, [services]);

  const categoryIcons = {
    all: Sparkles,
    runner: Bike,
    akademik: BookOpen,
    teknikal: Laptop,
    rekaan: Palette,
    dobi: Shirt,
  };

  const categoryPastels = {
    all: { bg: 'bg-red-50', text: 'text-selangor-red', border: 'border-red-100' },
    runner: { bg: 'bg-amber-50', text: 'text-amber-600', border: 'border-amber-100' },
    akademik: { bg: 'bg-blue-50', text: 'text-blue-600', border: 'border-blue-100' },
    teknikal: { bg: 'bg-emerald-50', text: 'text-emerald-600', border: 'border-emerald-100' },
    rekaan: { bg: 'bg-purple-50', text: 'text-purple-600', border: 'border-purple-100' },
    dobi: { bg: 'bg-sky-50', text: 'text-sky-600', border: 'border-sky-100' },
  };

  const isPenyedia = activeRole === 'penyedia' || currentUser?.active_role === 'penyedia';

  return (
    <div className="space-y-4 pb-20 max-w-lg mx-auto sm:max-w-xl">
      
      {/* 1. Dribbble-Style User Profile Greeting Header */}
      <div className="flex items-center justify-between gap-3 pt-2 px-1">
        <div className="flex items-center gap-3">
          <div className="relative">
            <img
              src={currentUser?.avatar || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80'}
              alt={currentUser?.full_name}
              className="w-12 h-12 rounded-2xl object-cover ring-2 ring-selangor-red/20 shadow-md"
            />
            <span className="absolute -bottom-0.5 -right-0.5 w-3.5 h-3.5 rounded-full bg-emerald-500 border-2 border-white ring-1 ring-emerald-400/50" />
          </div>
          <div>
            <h2 className="text-base font-extrabold text-slate-900 tracking-tight leading-tight">
              Hai, {currentUser?.full_name?.split(' ')[0] || 'Mahasiswa'} 👋
            </h2>
            <p className="text-xs font-medium text-slate-500">
              Cari Mikro-Gig & Jawatan Kampus
            </p>
          </div>
        </div>

        <div className="flex items-center gap-2">
          {/* Tawar Servis Button */}
          {onAddService && (
            <button
              onClick={onAddService}
              className="flex items-center gap-1 px-2.5 py-1.5 rounded-xl bg-gradient-to-r from-selangor-red to-selangor-dark text-white text-[11px] font-extrabold shadow-sm shadow-selangor-red/30 hover:shadow-selangor-red/50 active:scale-95 transition-all"
            >
              <span>+ Tawar Servis</span>
            </button>
          )}



          {/* Notification Squircle Button */}
          <button
            onClick={() => setShowNotificationModal(!showNotificationModal)}
            className="relative w-10 h-10 rounded-2xl bg-white border border-slate-200/90 flex items-center justify-center text-slate-700 hover:bg-slate-50 shadow-sm transition-all"
            title="Notifikasi Kampus"
          >
            <Bell className="w-4 h-4" />
            <span className="absolute top-2.5 right-2.5 w-2 h-2 rounded-full bg-rose-500 ring-2 ring-white animate-pulse" />
          </button>
        </div>
      </div>

      {/* Notification Dropdown / Modal */}
      {showNotificationModal && (
        <div className="p-3 bg-white rounded-2xl border border-slate-200 shadow-xl space-y-2 animate-fadeIn text-xs">
          <div className="flex justify-between items-center pb-1.5 border-b border-slate-100 font-bold text-slate-800">
            <span>Notifikasi Kampus Terkini</span>
            <button onClick={() => setShowNotificationModal(false)} className="text-slate-400 hover:text-slate-600">
              <X className="w-3.5 h-3.5" />
            </button>
          </div>
          <div className="p-2 bg-emerald-50 text-emerald-800 rounded-xl flex items-center gap-2 font-medium">
            <ShieldCheck className="w-4 h-4 text-emerald-600 shrink-0" />
            <span>Escrow Selamat Diaktifkan (100% Dilindungi)</span>
          </div>
          <div className="p-2 bg-red-50 text-red-900 rounded-xl flex items-center gap-2 font-medium">
            <Sparkles className="w-4 h-4 text-selangor-red shrink-0" />
            <span>Komisen rendah 5% sah bagi semua 21 IPTA</span>
          </div>
        </div>
      )}

      {/* 2. Kotak Carian Moden + Butang Penapis Squircle (Dribbble Signature) */}
      <div className="flex gap-2.5">
        <div className="relative flex-1">
          <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
          <input
            type="text"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            placeholder="Cari cth: runner kolej, tutor, laptop..."
            className="w-full pl-10 pr-9 py-3 bg-white border border-slate-200 rounded-2xl text-xs placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-selangor-red focus:border-transparent transition-all shadow-sm"
          />
          {searchTerm && (
            <button
              onClick={() => setSearchTerm('')}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600"
            >
              <X className="w-4 h-4" />
            </button>
          )}
        </div>
        
        {/* Butang Penapis Squircle Indigo */}
        <button
          onClick={() => setShowFilters(!showFilters)}
          className="w-12 h-12 rounded-2xl bg-selangor-red text-white flex items-center justify-center shadow-lg shadow-selangor-red/25 hover:bg-selangor-dark active:scale-95 transition-all shrink-0"
          title="Buka Penapis"
        >
          <SlidersHorizontal className="w-5 h-5" />
        </button>
      </div>

      {/* Drawer Penapis Boleh Laras */}
      {showFilters && (
        <div className="p-4 bg-white rounded-2xl border border-slate-200/90 shadow-md space-y-3.5 animate-fadeIn">
          <div className="flex justify-between items-center pb-2 border-b border-slate-100">
            <span className="text-xs font-bold text-slate-900 flex items-center gap-1.5">
              <Filter className="w-3.5 h-3.5 text-selangor-red" /> Penapisan Servis & Gig
            </span>
            <button
              onClick={() => {
                setMaxPrice(150);
                setSelectedCategory('all');
                setSelectedUniv('all');
                setOnlyHighRating(false);
              }}
              className="text-[11px] font-bold text-rose-600 hover:underline"
            >
              Set Semula
            </button>
          </div>

          <div>
            <div className="flex justify-between text-[11px] font-bold text-slate-600 mb-1">
              <span>Had Harga Maksimum</span>
              <span className="text-selangor-red font-extrabold">{formatRM(maxPrice)}</span>
            </div>
            <input
              type="range"
              min="5"
              max="150"
              step="5"
              value={maxPrice}
              onChange={(e) => setMaxPrice(Number(e.target.value))}
              className="w-full accent-selangor-red cursor-pointer"
            />
          </div>

          <div>
            <label className="flex items-center gap-2 text-xs font-semibold text-slate-700 cursor-pointer">
              <input
                type="checkbox"
                checked={onlyHighRating}
                onChange={(e) => setOnlyHighRating(e.target.checked)}
                className="rounded text-selangor-red focus:ring-selangor-red"
              />
              <span>Penarafan ≥ 4.0 Bintang Sahaja</span>
            </label>
          </div>
        </div>
      )}

      {/* Kad Inisiatif Komuniti Mahasiswa (Tema Merah & Kuning / Emas Mewah) */}
      <div className="rounded-3xl bg-gradient-to-br from-[#881337] via-[#B91C1C] via-[#C8102E] to-[#DC2626] p-4 text-white shadow-xl shadow-red-950/25 relative overflow-hidden border border-red-500/30">
        {/* Glow Kuning Emas Diraja */}
        <div className="absolute -top-12 -right-12 w-36 h-36 bg-[#FFCC00]/25 rounded-full blur-2xl pointer-events-none" />
        <div className="absolute bottom-0 right-0 w-24 h-24 bg-white/5 rounded-full pointer-events-none" />
        <div className="absolute left-0 top-0 bottom-0 w-1.5 bg-gradient-to-b from-[#FFCC00] to-[#F59E0B]" />

        <div className="relative z-10 pl-2 space-y-2.5">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <span className="px-2 py-0.5 rounded-full bg-[#FFCC00] text-[#7F1D1D] font-black text-[9px] uppercase tracking-wide flex items-center gap-1 shadow-xs">
                <Sparkles className="w-3 h-3" />
                KOMUNITI MIKRO-GIG KAMPUS
              </span>
            </div>
            <span className="text-[10px] bg-white/20 px-2 py-0.5 rounded-full font-bold border border-white/20">
              🛡️ Escrow 100%
            </span>
          </div>

          <div>
            <h3 className="text-sm sm:text-base font-extrabold tracking-tight text-white">
              Ekosistem Mikro-Gig & Perlindungan Escrow Mahasiswa
            </h3>
            <p className="text-[11px] text-white/90 leading-relaxed mt-1">
              Menghubungkan mahasiswa merentasi 21 IPTA Malaysia. Jana pendapatan sampingan halal dengan jaminan pelepasan dana telus.
            </p>
          </div>

          <div className="flex items-center gap-2 pt-0.5">
            <button
              onClick={() => {
                setSelectedUniv('all');
                setSelectedCategory('all');
                setSearchTerm('');
              }}
              className="px-3 py-1.5 rounded-xl bg-gradient-to-r from-[#FFCC00] to-[#F59E0B] text-[#7F1D1D] font-extrabold text-xs shadow-md shadow-amber-500/20 hover:brightness-105 active:scale-95 transition-all flex items-center gap-1"
            >
              <Sparkles className="w-3 h-3 text-[#7F1D1D]" />
              <span>Terokai Semua Gig</span>
            </button>
            <div className="flex items-center gap-1.5 text-[10px] text-white/80 font-bold bg-black/20 px-2.5 py-1.5 rounded-xl border border-white/10">
              <span>🎓 21 IPTA</span>
              <span>•</span>
              <span>⚡ Pantas</span>
              <span>•</span>
              <span>🔒 Amanah</span>
            </div>
          </div>
        </div>
      </div>

      {/* 3. "Peluang Gig Popular 🔥" (Horizontal Card Carousel - Dribbble Signature) */}
      <div className="space-y-2.5">
        <div className="flex justify-between items-center px-1">
          <h3 className="text-sm font-extrabold text-slate-900 tracking-tight flex items-center gap-1.5">
            <span>Peluang Gig Popular</span>
            <span className="text-xs">🔥</span>
          </h3>
          <button
            onClick={() => {
              setSelectedCategory('all');
              setSelectedUniv('all');
              setSearchTerm('');
            }}
            className="text-xs font-bold text-selangor-red hover:text-selangor-dark"
          >
            Lihat Semua
          </button>
        </div>

        {/* Carousel Kad Gelap Mewah */}
        <div className="flex gap-3 overflow-x-auto pb-2 pt-1 scrollbar-none snap-x snap-mandatory">
          {popularServices.map((srv) => {
            const isBookmarked = bookmarkedIds.has(srv.service_id);
            return (
              <div
                key={srv.service_id}
                onClick={() => onSelectService(srv)}
                className="w-72 shrink-0 rounded-3xl bg-gradient-to-br from-slate-900 via-red-950 to-slate-900 p-4 text-white shadow-xl shadow-red-950/25 cursor-pointer snap-start relative overflow-hidden group hover:scale-[1.01] transition-all"
              >
                {/* Glow Aksen */}
                <div className="absolute -top-10 -right-10 w-28 h-28 bg-selangor-red/20 rounded-full blur-2xl pointer-events-none" />

                {/* Baris Atas: Logo Universiti + Tag + Bookmark */}
                <div className="flex items-center justify-between mb-3 relative z-10">
                  <div className="flex items-center gap-2.5">
                    <div className="w-10 h-10 rounded-2xl bg-white p-1.5 flex items-center justify-center shadow-md">
                      <IPTALogoBadge univ={srv.university} size="sm" showName={false} />
                    </div>
                    <div>
                      <span className="text-xs font-extrabold text-white block">
                        {srv.university.split(' ')[0]}
                      </span>
                      <span className="px-2 py-0.5 rounded-md bg-cyan-400/20 text-cyan-300 text-[9.5px] font-extrabold uppercase tracking-wider">
                        Separuh Masa
                      </span>
                    </div>
                  </div>

                  <button
                    onClick={(e) => toggleBookmark(srv.service_id, e)}
                    className="w-8 h-8 rounded-full bg-white/10 hover:bg-white/20 flex items-center justify-center backdrop-blur-md transition-all"
                  >
                    <Bookmark className={`w-4 h-4 ${isBookmarked ? 'fill-cyan-400 text-cyan-400' : 'text-white/70'}`} />
                  </button>
                </div>

                {/* Bahagian Tengah: Tajuk Gig & Lokasi */}
                <div className="mb-4 relative z-10">
                  <h4 className="text-sm font-extrabold text-white line-clamp-2 leading-snug group-hover:text-cyan-200 transition-colors">
                    {srv.title}
                  </h4>
                  <div className="flex items-center gap-1.5 mt-2 text-[11px] text-slate-300 font-medium">
                    <MapPin className="w-3.5 h-3.5 text-cyan-400 shrink-0" />
                    <span className="truncate">{srv.college} • {srv.university}</span>
                  </div>
                </div>

                {/* Baris Bawah: Harga & Butang Pohon */}
                <div className="flex items-center justify-between pt-2 border-t border-white/10 relative z-10">
                  <div className="flex items-baseline gap-1">
                    <span className="text-base font-extrabold text-white">
                      {formatRM(srv.price)}
                    </span>
                    <span className="text-[10px] text-slate-400">/ tugas</span>
                  </div>

                  <div className="flex items-center gap-1 px-3 py-1.5 rounded-xl bg-cyan-400 text-slate-950 text-xs font-extrabold shadow-sm group-hover:bg-cyan-300 transition-colors">
                    <span>Pohon</span>
                    <ArrowUpRight className="w-3.5 h-3.5" />
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* 4. "Kategori Mikro-Gig" (Squircle Pastel Tiles - Dribbble Style) */}
      <div className="space-y-2.5">
        <div className="flex justify-between items-center px-1">
          <h3 className="text-sm font-extrabold text-slate-900 tracking-tight flex items-center gap-1.5">
            <span>Kategori Mikro-Gig</span>
            <Sparkles className="w-3.5 h-3.5 text-selangor-red" />
          </h3>
          {onAddService ? (
            <button
              onClick={onAddService}
              className="text-xs font-bold text-selangor-red hover:text-selangor-dark flex items-center gap-1 bg-red-50 hover:bg-red-100 px-2.5 py-1 rounded-xl transition-all"
            >
              <span>+ Cipta Servis</span>
            </button>
          ) : (
            <span className="text-xs text-slate-400 font-semibold">{CATEGORIES.length} Kategori</span>
          )}
        </div>

        {/* Squircle Kategori */}
        <div className="grid grid-cols-3 sm:grid-cols-6 gap-2.5">
          {CATEGORIES.map((cat) => {
            const isSelected = selectedCategory === cat.id;
            const IconComponent = categoryIcons[cat.id] || Sparkles;
            const pastel = categoryPastels[cat.id] || categoryPastels.all;

            return (
              <button
                key={cat.id}
                onClick={() => setSelectedCategory(cat.id)}
                className={`flex flex-col items-center justify-center p-3 rounded-2xl transition-all border ${
                  isSelected
                    ? 'bg-selangor-red text-white border-selangor-red shadow-md shadow-selangor-red/25 scale-[1.02]'
                    : `${pastel.bg} ${pastel.border} hover:scale-[1.01]`
                }`}
              >
                <div className={`w-10 h-10 rounded-xl flex items-center justify-center mb-1.5 ${
                  isSelected ? 'bg-white/20 text-white' : `${pastel.text}`
                }`}>
                  <IconComponent className="w-5 h-5" />
                </div>
                <span className={`text-[11px] font-bold text-center truncate w-full ${
                  isSelected ? 'text-white' : 'text-slate-800'
                }`}>
                  {cat.name}
                </span>
              </button>
            );
          })}
        </div>
      </div>

      {/* 5. "Koleksi 21 IPTA Malaysia" (Horizontal Campus Bar) */}
      <div className="space-y-2">
        <div className="flex justify-between items-center px-1">
          <h3 className="text-xs font-bold text-slate-700 uppercase tracking-wider flex items-center gap-1.5">
            <GraduationCap className="w-3.5 h-3.5 text-selangor-red" />
            <span>Koleksi 21 IPTA Malaysia</span>
          </h3>
          <button 
            onClick={() => setSelectedUniv('all')}
            className={`text-xs font-bold ${selectedUniv === 'all' ? 'text-selangor-red underline' : 'text-slate-400 hover:text-slate-600'}`}
          >
            Semua (21)
          </button>
        </div>

        <div className="flex items-center gap-2 overflow-x-auto pb-1 pt-0.5 scrollbar-none">
          {ALL_IPTA.map((ipta) => {
            const isSelected = selectedUniv.toLowerCase() === ipta.code.toLowerCase();
            return (
              <button
                key={ipta.code}
                onClick={() => setSelectedUniv(isSelected ? 'all' : ipta.code)}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold whitespace-nowrap transition-all border ${
                  isSelected
                    ? 'bg-selangor-red text-white border-selangor-red shadow-sm shadow-selangor-red/20'
                    : 'bg-white text-slate-700 hover:bg-slate-50 border-slate-200'
                }`}
              >
                <IPTALogoBadge univ={ipta.code} size="xs" showName={false} />
                <span>{ipta.code}</span>
              </button>
            );
          })}
        </div>
      </div>

      {/* 6. "Jawatan & Gig Terkini" (Vertical List - Dribbble Clean Job Cards) */}
      <div className="space-y-2.5 pt-1">
        <div className="flex justify-between items-center px-1">
          <h3 className="text-sm font-extrabold text-slate-900 tracking-tight">
            Jawatan & Gig Terkini ({filteredServices.length})
          </h3>
          <div className="flex items-center gap-1 text-[11px] text-emerald-600 font-extrabold bg-emerald-50 px-2 py-0.5 rounded-lg border border-emerald-100">
            <ShieldCheck className="w-3.5 h-3.5" />
            <span>100% Escrow</span>
          </div>
        </div>

        {filteredServices.length === 0 ? (
          <div className="bg-white rounded-3xl p-8 text-center border border-dashed border-slate-200">
            <Search className="w-10 h-10 text-slate-300 mx-auto mb-2" />
            <h4 className="font-extrabold text-slate-700 text-sm">Tiada gig dijumpai</h4>
            <p className="text-xs text-slate-500 mt-1">Cuba laraskan kata kunci carian atau penapis harga anda.</p>
          </div>
        ) : (
          <div className="space-y-2.5">
            {filteredServices.map((srv) => {
              const isBookmarked = bookmarkedIds.has(srv.service_id);
              return (
                <div
                  key={srv.service_id}
                  onClick={() => onSelectService(srv)}
                  className="bg-white rounded-2xl p-3.5 border border-slate-200/90 shadow-sm hover:shadow-md hover:border-red-200 transition-all cursor-pointer flex items-center justify-between gap-3 group"
                >
                  {/* Kiri: Logo IPTA Squircle & Maklumat Gig */}
                  <div className="flex items-center gap-3 min-w-0">
                    <div className="w-12 h-12 rounded-2xl bg-slate-50 border border-slate-100 p-2 flex items-center justify-center shrink-0 group-hover:scale-105 transition-transform">
                      <IPTALogoBadge univ={srv.university} size="sm" showName={false} />
                    </div>

                    <div className="min-w-0">
                      <h4 className="text-xs sm:text-sm font-extrabold text-slate-900 truncate leading-snug group-hover:text-selangor-red transition-colors">
                        {srv.title}
                      </h4>
                      <div className="flex items-center gap-1.5 mt-0.5 text-[11px] text-slate-500 font-medium">
                        <span className="truncate">{srv.provider_name}</span>
                        <CheckCircle2 className="w-3 h-3 text-selangor-red shrink-0" />
                        <span>•</span>
                        <span className="truncate text-slate-400">{srv.college}</span>
                      </div>

                      {/* Tag Chips */}
                      <div className="flex items-center gap-1.5 mt-1.5">
                        <span className="px-2 py-0.5 rounded-md bg-slate-100 text-slate-600 text-[10px] font-bold">
                          {srv.university.split(' ')[0]}
                        </span>
                        <span className="flex items-center gap-0.5 text-[10px] font-extrabold text-amber-500">
                          <Star className="w-3 h-3 fill-amber-400 text-amber-400" />
                          <span>{srv.rating}</span>
                        </span>
                      </div>
                    </div>
                  </div>

                  {/* Kanan: Harga & Bookmark */}
                  <div className="text-right shrink-0 flex flex-col items-end justify-between h-12">
                    <button
                      onClick={(e) => toggleBookmark(srv.service_id, e)}
                      className="text-slate-400 hover:text-selangor-red p-0.5"
                    >
                      <Bookmark className={`w-4 h-4 ${isBookmarked ? 'fill-indigo-600 text-selangor-red' : ''}`} />
                    </button>
                    <span className="text-sm font-extrabold text-selangor-red">
                      {formatRM(srv.price)}
                    </span>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

    </div>
  );
}
