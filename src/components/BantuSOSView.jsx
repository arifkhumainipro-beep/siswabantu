import React, { useState } from 'react';
import { 
  Flame, 
  PlusCircle, 
  Clock, 
  MapPin, 
  AlertTriangle, 
  Send, 
  Sparkles, 
  CheckCircle2, 
  UserCheck, 
  Bike,
  ShieldAlert
} from 'lucide-react';
import { formatRM } from '../utils/security';
import IPTALogoBadge from './IPTALogoBadge';

export default function BantuSOSView({ 
  sosRequests, 
  onPostSOS, 
  onOfferHelp, 
  currentUser 
}) {
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [reward, setReward] = useState('10.00');
  const [deadline, setDeadline] = useState('Sebelum 5:00 PM');
  const [category, setCategory] = useState('runner');

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!title.trim() || !description.trim()) return;

    onPostSOS({
      title,
      description,
      reward: parseFloat(reward) || 10.00,
      deadline,
      category,
      buyer_id: currentUser?.user_id,
      buyer_name: currentUser?.full_name,
      buyer_avatar: currentUser?.avatar,
      buyer_college: currentUser?.college,
      university: currentUser?.university_name,
    });

    setTitle('');
    setDescription('');
    setShowCreateModal(false);
  };

  return (
    <div className="space-y-4 p-3 sm:p-5">
      
      {/* Header SOS Board */}
      <div className="bg-gradient-to-r from-amber-500 via-orange-600 to-rose-600 rounded-3xl p-5 sm:p-6 text-white shadow-xl shadow-amber-500/20 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <div className="flex items-center gap-2 mb-1.5">
            <span className="flex items-center gap-1.5 px-3 py-1 rounded-full bg-white/20 backdrop-blur-md text-[10px] font-extrabold uppercase tracking-wider">
              <Flame className="w-3.5 h-3.5 fill-amber-300 text-amber-300 animate-pulse" /> Papan Bantu SOS Kampus
            </span>
            <span className="text-[11px] text-amber-100 font-medium">Bantuan Pantas Pelajar</span>
          </div>
          <h2 className="text-xl sm:text-2xl font-extrabold tracking-tight">
            Perlukan Bantuan Kilat? Siarkan di Sini!
          </h2>
          <p className="text-xs text-amber-100 max-w-md mt-1 leading-relaxed">
            Rakan mahasiswa sekitar kolej kediaman sedia bertindak pantas dengan perlindungan Escrow automatik.
          </p>
        </div>

        <button
          onClick={() => setShowCreateModal(true)}
          className="px-4 py-2.5 rounded-2xl bg-white text-slate-900 font-extrabold text-xs flex items-center gap-2 shadow-lg hover:bg-amber-50 active:scale-95 transition-all shrink-0"
        >
          <PlusCircle className="w-4 h-4 text-rose-600" />
          <span>Siarkan Bantu SOS</span>
        </button>
      </div>

      {/* Info Escrow Alert */}
      <div className="bg-amber-50 border border-amber-200/80 rounded-2xl p-3.5 flex items-start gap-3 text-xs text-amber-900">
        <ShieldAlert className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
        <p className="leading-relaxed">
          <strong>Peraturan Bantu SOS:</strong> Upah akan disimpan dengan selamat di akaun <strong>Escrow SiswaBantu</strong> dan hanya dilepaskan kepada pembantu selepas tugasan disahkan siap dengan memuaskan.
        </p>
      </div>

      {/* Senarai Permintaan SOS Aktif */}
      <div className="space-y-3">
        {sosRequests.map((sos) => (
          <div 
            key={sos.sos_id}
            className="bg-white rounded-2xl border border-slate-200/90 p-4 sm:p-5 shadow-sm hover:border-amber-400 hover:shadow-md transition-all space-y-3"
          >
            <div className="flex items-start justify-between gap-3">
              <div className="flex items-start gap-3">
                <img
                  src={sos.buyer_avatar}
                  alt={sos.buyer_name}
                  className="w-10 h-10 rounded-full object-cover ring-2 ring-amber-200"
                />
                <div>
                  <h3 className="font-extrabold text-sm sm:text-base text-slate-900 leading-snug">
                    {sos.title}
                  </h3>
                  <div className="flex flex-wrap items-center gap-2 mt-1 text-[11px] text-slate-500">
                    <span className="font-bold text-slate-800">{sos.buyer_name}</span>
                    <span>•</span>
                    <span className="flex items-center gap-1.5 text-slate-600">
                      <IPTALogoBadge univ={sos.university || 'UiTM'} size="xs" showName={false} />
                      <span>{sos.buyer_college}, {sos.university || 'Kampus'}</span>
                    </span>
                  </div>
                </div>
              </div>

              <div className="text-right shrink-0">
                <span className="px-3 py-1 rounded-full bg-amber-100 text-amber-900 text-xs font-extrabold block">
                  Upah {formatRM(sos.reward)}
                </span>
                <span className="text-[10px] text-slate-400 mt-1 block">
                  {sos.created_at}
                </span>
              </div>
            </div>

            <p className="text-xs text-slate-600 leading-relaxed bg-slate-50 p-3 rounded-xl border border-slate-100">
              "{sos.description}"
            </p>

            <div className="flex items-center justify-between pt-1 text-xs">
              <div className="flex items-center gap-1.5 text-rose-600 font-bold text-[11px]">
                <Clock className="w-3.5 h-3.5" />
                <span>Kritikal: {sos.deadline}</span>
              </div>

              <button
                onClick={() => onOfferHelp(sos)}
                className="px-4 py-2 rounded-xl bg-gradient-to-r from-indigo-600 to-cyan-600 hover:from-indigo-700 hover:to-cyan-700 text-white text-xs font-extrabold shadow-md shadow-indigo-500/20 active:scale-95 transition-all flex items-center gap-1.5"
              >
                <Sparkles className="w-3.5 h-3.5 text-cyan-200" />
                <span>Tawar Bantuan ({sos.offers_count})</span>
              </button>
            </div>
          </div>
        ))}
      </div>

      {/* Modal Cipta Permintaan SOS Baharu */}
      {showCreateModal && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 animate-fadeIn">
          <div className="bg-white rounded-3xl max-w-md w-full p-5 shadow-2xl border border-slate-200 space-y-4">
            <div className="flex justify-between items-center pb-2 border-b border-slate-100">
              <div className="flex items-center gap-2">
                <div className="w-8 h-8 rounded-xl bg-amber-100 text-amber-600 flex items-center justify-center font-bold">
                  <Flame className="w-4 h-4 fill-amber-500" />
                </div>
                <h3 className="font-extrabold text-slate-900 text-sm sm:text-base">
                  Siarkan Permintaan Bantu SOS
                </h3>
              </div>
              <button
                onClick={() => setShowCreateModal(false)}
                className="text-slate-400 hover:text-slate-600 text-lg font-bold"
              >
                ✕
              </button>
            </div>

            <form onSubmit={handleSubmit} className="space-y-3">
              <div>
                <label className="text-xs font-bold text-slate-700 block mb-1">
                  Apa yang anda perlukan segera? *
                </label>
                <input
                  type="text"
                  required
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  placeholder="Cth: Runner belikan ubat batuk di farmasi luar kampus"
                  className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-medium outline-none focus:ring-2 focus:ring-amber-500"
                />
              </div>

              <div>
                <label className="text-xs font-bold text-slate-700 block mb-1">
                  Keterangan Terperinci & Lokasi *
                </label>
                <textarea
                  required
                  rows={3}
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  placeholder="Nyatakan bilik kolej, barang yang perlu dibeli, dan sebarang pesanan khas..."
                  className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-medium outline-none focus:ring-2 focus:ring-amber-500"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <div className="flex justify-between items-center mb-1">
                    <label className="text-xs font-bold text-slate-700 block">
                      Cadangan Upah (RM) *
                    </label>
                  </div>
                  <input
                    type="number"
                    step="1"
                    min="5"
                    required
                    value={reward}
                    onChange={(e) => setReward(e.target.value)}
                    className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-bold text-indigo-700 outline-none focus:ring-2 focus:ring-indigo-600"
                  />
                  {/* Preset reward buttons */}
                  <div className="flex gap-1.5 mt-1.5">
                    {['5.00', '10.00', '15.00', '20.00'].map((amt) => (
                      <button
                        key={amt}
                        type="button"
                        onClick={() => setReward(amt)}
                        className="px-1.5 py-0.5 rounded bg-slate-100 hover:bg-slate-200 text-[10px] font-bold text-slate-600"
                      >
                        RM{parseInt(amt)}
                      </button>
                    ))}
                  </div>
                </div>

                <div>
                  <label className="text-xs font-bold text-slate-700 block mb-1">
                    Jangka Masa Diperlukan *
                  </label>
                  <input
                    type="text"
                    required
                    value={deadline}
                    onChange={(e) => setDeadline(e.target.value)}
                    placeholder="Cth: Dalam 30 minit"
                    className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-medium outline-none focus:ring-2 focus:ring-indigo-600"
                  />
                </div>
              </div>

              <div className="pt-2">
                <button
                  type="submit"
                  className="w-full py-3 rounded-xl bg-gradient-to-r from-indigo-600 via-indigo-700 to-cyan-600 hover:from-indigo-700 hover:to-cyan-700 text-white font-extrabold text-xs shadow-md shadow-indigo-500/20 active:scale-95 transition-all flex items-center justify-center gap-1.5"
                >
                  <Flame className="w-4 h-4 fill-white" />
                  <span>Terbitkan ke Papan Kampus Sekarang</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

    </div>
  );
}

