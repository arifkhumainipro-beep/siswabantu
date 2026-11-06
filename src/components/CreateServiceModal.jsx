import React, { useState } from 'react';
import { PlusCircle, Image as ImageIcon, Sparkles, Clock, DollarSign, X, GraduationCap, MapPin } from 'lucide-react';
import { CATEGORIES } from '../data/mockData';
import { ALL_IPTA } from '../data/iptaData';

export default function CreateServiceModal({ isOpen, onClose, onSaveService, currentUser }) {
  const [title, setTitle] = useState('');
  const [category, setCategory] = useState('teknikal');
  const [selectedIpta, setSelectedIpta] = useState(currentUser?.university_name || 'Universiti Teknologi MARA (UiTM)');
  const [college, setCollege] = useState(currentUser?.college || 'Kolej Kediaman Mahasiswa');
  const [description, setDescription] = useState('');
  const [price, setPrice] = useState('30.00');
  const [priceType, setPriceType] = useState('Tetap');
  const [slaHours, setSlaHours] = useState('24 Jam');
  const [imageUrl, setImageUrl] = useState('https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80');

  if (!isOpen) return null;

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!title.trim() || !description.trim()) return;

    const selectedCatObj = CATEGORIES.find(c => c.id === category) || CATEGORIES[1];

    const newService = {
      service_id: `srv-${Date.now()}`,
      provider_id: currentUser?.user_id,
      provider_name: currentUser?.full_name,
      provider_avatar: currentUser?.avatar,
      provider_matric: currentUser?.matric_no,
      provider_kyc: true,
      university: selectedIpta,
      college: college.trim() || 'Kolej Kediaman',
      title,
      category,
      category_name: selectedCatObj.name,
      description,
      price: parseFloat(price) || 20.00,
      price_type: priceType,
      sla_hours: slaHours,
      rating: 5.0,
      reviews_count: 0,
      completed_orders: 0,
      images: [imageUrl],
      is_active: true,
      is_online: true,
    };

    onSaveService(newService);
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 animate-fadeIn">
      <div className="bg-white rounded-3xl max-w-lg w-full max-h-[90vh] overflow-y-auto p-5 sm:p-6 shadow-2xl border border-slate-200 space-y-4">
        
        {/* Modal Header */}
        <div className="flex justify-between items-center pb-3 border-b border-slate-100">
          <div className="flex items-center gap-2">
            <div className="w-9 h-9 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center font-bold">
              <Sparkles className="w-5 h-5" />
            </div>
            <div>
              <h2 className="font-extrabold text-slate-900 text-base">
                Cipta Tawaran Servis Baharu (FR-2.1)
              </h2>
              <p className="text-[11px] text-slate-500 font-medium">
                Penyedia Bantu Terverifikasi Kad Matrik
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 flex items-center justify-center font-bold text-sm transition-all"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="space-y-3.5">
          {/* Pilihan Kampus IPTA (20 IPTA + UniSEL) */}
          <div className="p-3 bg-indigo-50/60 border border-indigo-100 rounded-2xl space-y-2">
            <div className="flex items-center gap-1.5 text-xs font-extrabold text-indigo-900">
              <GraduationCap className="w-4 h-4 text-indigo-600" />
              <span>Pilih Kampus / IPTA Servis Ditawarkan *</span>
            </div>
            <select
              value={selectedIpta}
              onChange={(e) => setSelectedIpta(e.target.value)}
              className="w-full text-xs bg-white border border-indigo-200 rounded-xl p-2.5 font-bold text-slate-800 outline-none focus:ring-2 focus:ring-indigo-600"
            >
              {ALL_IPTA.map((ipta) => (
                <option key={ipta.id} value={`${ipta.fullName} (${ipta.code})`}>
                  {ipta.code} - {ipta.shortName} ({ipta.state})
                </option>
              ))}
            </select>
            <div>
              <label className="text-[11px] font-bold text-slate-600 block mb-1">
                Kolej Kediaman / Zon Liputan Servis:
              </label>
              <input
                type="text"
                value={college}
                onChange={(e) => setCollege(e.target.value)}
                placeholder="Cth: Kolej Mawar, Kolej KHAR atau Seluruh Kampus"
                className="w-full text-xs bg-white border border-indigo-200 rounded-xl p-2 font-medium outline-none focus:ring-2 focus:ring-indigo-600"
              />
            </div>
          </div>

          {/* Tajuk Servis */}
          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">
              Tajuk Servis Tawaran *
            </label>
            <input
              type="text"
              required
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="Cth: Format & Lajukan Laptop, Bersihkan Kipas & Servis Windows"
              className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-medium outline-none focus:ring-2 focus:ring-indigo-600"
            />
          </div>

          {/* Kategori */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">
                Kategori Servis *
              </label>
              <select
                value={category}
                onChange={(e) => setCategory(e.target.value)}
                className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-medium outline-none focus:ring-2 focus:ring-indigo-600"
              >
                {CATEGORIES.filter(c => c.id !== 'all').map((c) => (
                  <option key={c.id} value={c.id}>{c.name}</option>
                ))}
              </select>
            </div>

            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">
                Model Harga *
              </label>
              <select
                value={priceType}
                onChange={(e) => setPriceType(e.target.value)}
                className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-medium outline-none focus:ring-2 focus:ring-indigo-600"
              >
                <option value="Tetap">Harga Tetap (Per Job)</option>
                <option value="Mengikut Jam">Mengikut Jam (/ jam)</option>
              </select>
            </div>
          </div>

          {/* Harga & SLA */}
          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">
                Kadar Harga (RM) *
              </label>
              <div className="relative">
                <span className="absolute left-3 top-1/2 -translate-y-1/2 text-xs font-extrabold text-slate-400">RM</span>
                <input
                  type="number"
                  step="0.50"
                  min="2"
                  required
                  value={price}
                  onChange={(e) => setPrice(e.target.value)}
                  className="w-full pl-10 pr-3 py-2.5 text-xs bg-slate-50 border border-slate-200 rounded-xl font-extrabold text-indigo-700 outline-none focus:ring-2 focus:ring-indigo-600"
                />
              </div>
            </div>

            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">
                Tempoh Siap (SLA) *
              </label>
              <input
                type="text"
                required
                value={slaHours}
                onChange={(e) => setSlaHours(e.target.value)}
                placeholder="Cth: 24 Jam atau 30 Minit"
                className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-medium outline-none focus:ring-2 focus:ring-indigo-600"
              />
            </div>
          </div>

          {/* Keterangan */}
          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">
              Keterangan Penuh & Kelebihan Servis *
            </label>
            <textarea
              required
              rows={3}
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="Terangkan skop kerja anda, perisian yang digunakan, atau kawasan kolej yang anda liputi..."
              className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-medium outline-none focus:ring-2 focus:ring-indigo-600"
            />
          </div>

          {/* Gambar Rujukan */}
          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">
              Pautan Gambar Sampel Kerja
            </label>
            <div className="flex gap-2">
              <input
                type="url"
                value={imageUrl}
                onChange={(e) => setImageUrl(e.target.value)}
                className="flex-1 text-xs bg-slate-50 border border-slate-200 rounded-xl p-2 font-mono text-slate-600 outline-none"
              />
              <img
                src={imageUrl}
                alt="Preview"
                className="w-10 h-10 rounded-lg object-cover border border-slate-200"
              />
            </div>
          </div>

          {/* Komisen Platform Info */}
          <div className="p-3 bg-slate-50 rounded-xl border border-slate-200 text-xs space-y-1">
            <div className="flex justify-between text-slate-600">
              <span>Harga Servis Ditawarkan:</span>
              <strong className="text-slate-800">RM {parseFloat(price || 0).toFixed(2)}</strong>
            </div>
            <div className="flex justify-between text-slate-600">
              <span>Komisen Platform (5%):</span>
              <strong className="text-amber-600">- RM {(parseFloat(price || 0) * 0.05).toFixed(2)}</strong>
            </div>
            <div className="flex justify-between font-extrabold text-emerald-700 pt-1 border-t border-slate-200">
              <span>Pendapatan Bersih Anda (95%):</span>
              <span>RM {(parseFloat(price || 0) * 0.95).toFixed(2)}</span>
            </div>
          </div>

          {/* Submit */}
          <div className="pt-2">
            <button
              type="submit"
              className="w-full py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-extrabold text-xs shadow-md shadow-indigo-500/20 active:scale-95 transition-all flex items-center justify-center gap-1.5"
            >
              <PlusCircle className="w-4 h-4" />
              <span>Terbitkan Servis Sekarang (is_active = true)</span>
            </button>
          </div>
        </form>

      </div>
    </div>
  );
}

