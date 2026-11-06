import React, { useState } from 'react';
import { 
  Star, 
  Clock, 
  ShieldCheck, 
  CheckCircle2, 
  MapPin, 
  MessageSquare, 
  CreditCard, 
  X, 
  Share2,
  Sparkles,
  ArrowRight,
  Send,
  ThumbsUp
} from 'lucide-react';
import { formatRM } from '../utils/security';
import IPTALogoBadge from './IPTALogoBadge';

export default function ServiceDetailModal({ 
  service, 
  onClose, 
  onBook, 
  onChat 
}) {
  const [showReviewForm, setShowReviewForm] = useState(false);
  const [userRating, setUserRating] = useState(5);
  const [userComment, setUserComment] = useState('');
  const [reviewsList, setReviewsList] = useState([
    {
      id: 1,
      name: 'Nur Sarah Balqis',
      matric: '2024881921',
      date: 'Semalam',
      rating: 5,
      comment: 'Servis sangat pantas dan mesra! Hasil kerja kemas dan tepat pada masanya.',
      tags: ['Pantas ⚡️', 'Amanah 🔒'],
    },
    {
      id: 2,
      name: 'Khairul Anwar',
      matric: '2023910022',
      date: '3 hari lepas',
      rating: 5,
      comment: 'Sangat recommended untuk warga kampus. Harga berpatutan khas bajet siswa.',
      tags: ['Harga Berpatutan 💰'],
    }
  ]);
  const [currentRating, setCurrentRating] = useState(service?.rating || 4.9);
  const [reviewsCount, setReviewsCount] = useState(service?.reviews_count || 12);

  if (!service) return null;

  const handleAddReview = (e) => {
    e.preventDefault();
    if (!userComment.trim()) return;

    const newRev = {
      id: Date.now(),
      name: 'Anda (Mahasiswa Sah)',
      matric: '2026119900',
      date: 'Baru tadi',
      rating: userRating,
      comment: userComment.trim(),
      tags: ['Siswa Sah 🎓', 'Puas Hati ⭐'],
    };

    setReviewsList([newRev, ...reviewsList]);
    const newTotal = reviewsCount + 1;
    const newAvg = ((currentRating * reviewsCount) + userRating) / newTotal;
    setCurrentRating(parseFloat(newAvg.toFixed(2)));
    setReviewsCount(newTotal);
    setUserComment('');
    setShowReviewForm(false);
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/65 backdrop-blur-sm flex items-center justify-center p-3 sm:p-4 animate-fadeIn">
      <div className="bg-white rounded-3xl max-w-lg w-full max-h-[92vh] overflow-y-auto shadow-2xl border border-slate-200 flex flex-col">
        
        {/* Cover Image & Close Button */}
        <div className="relative h-56 sm:h-64 w-full bg-slate-900 shrink-0">
          <img
            src={service.images[0]}
            alt={service.title}
            className="w-full h-full object-cover"
          />
          <button
            onClick={onClose}
            className="absolute top-3 right-3 w-8 h-8 rounded-full bg-black/60 hover:bg-black/80 text-white flex items-center justify-center text-sm font-bold transition-all"
          >
            <X className="w-4 h-4" />
          </button>
          
          <div className="absolute bottom-3 left-3 px-2.5 py-1 rounded-xl bg-black/60 backdrop-blur-md text-white text-xs font-bold">
            {service.category_name}
          </div>
        </div>

        {/* Modal Body */}
        <div className="p-5 sm:p-6 space-y-4 flex-1">
          
          {/* Header Title & Price */}
          <div className="flex justify-between items-start gap-3">
            <div>
              <h2 className="text-lg font-extrabold text-slate-900 leading-snug">
                {service.title}
              </h2>
              <div className="flex items-center gap-2 mt-1.5 text-xs text-slate-500">
                <span className="flex items-center gap-1 text-amber-700 font-extrabold">
                  <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-400" />
                  {currentRating.toFixed(1)}
                  <span className="text-slate-400 font-normal">({reviewsCount} ulasan)</span>
                </span>
                <span>•</span>
                <span className="flex items-center gap-1 font-semibold text-slate-600">
                  <Clock className="w-3.5 h-3.5 text-slate-400" /> {service.sla_hours}
                </span>
              </div>
            </div>

            <div className="text-right shrink-0">
              <span className="text-2xl font-extrabold text-indigo-600 block">
                {formatRM(service.price)}
              </span>
              <span className="text-[10px] text-slate-500 font-medium">
                {service.price_type === 'Mengikut Jam' ? 'kadar per jam' : 'harga tetap'}
              </span>
            </div>
          </div>

          {/* Provider Profile Card */}
          <div className="p-3.5 rounded-2xl bg-slate-50 border border-slate-200/80 flex items-center justify-between gap-3">
            <div className="flex items-center gap-3">
              <img
                src={service.provider_avatar}
                alt={service.provider_name}
                className="w-12 h-12 rounded-full object-cover ring-2 ring-indigo-500/20 shadow-sm"
              />
              <div>
                <div className="flex items-center gap-1.5">
                  <h4 className="font-extrabold text-xs text-slate-900">{service.provider_name}</h4>
                  {service.provider_kyc && (
                    <span className="px-1.5 py-0.5 rounded bg-emerald-100 text-emerald-800 text-[9px] font-bold flex items-center gap-0.5">
                      <CheckCircle2 className="w-2.5 h-2.5" /> e-KYC Sah
                    </span>
                  )}
                </div>
                <div className="flex items-center gap-1.5 mt-1">
                  <IPTALogoBadge univ={service.university} size="xs" showName={true} />
                </div>
                <span className="text-[10px] text-emerald-600 font-semibold block mt-0.5">
                  ● {service.college || 'Aktif di Kampus'}
                </span>
              </div>
            </div>

            <button
              onClick={() => onChat(service)}
              className="px-3 py-1.5 rounded-xl bg-white hover:bg-slate-100 border border-slate-200 text-slate-700 font-bold text-xs flex items-center gap-1 shadow-sm transition-all"
            >
              <MessageSquare className="w-3.5 h-3.5 text-indigo-600" />
              <span>Sembang</span>
            </button>
          </div>

          {/* Keterangan Servis */}
          <div>
            <h4 className="text-xs font-bold text-slate-800 uppercase tracking-wider mb-1.5">
              Keterangan Servis & Skop Kerja
            </h4>
            <p className="text-xs text-slate-600 leading-relaxed bg-slate-50/50 p-3 rounded-2xl border border-slate-100">
              {service.description}
            </p>
          </div>

          {/* Escrow Guarantee Highlight */}
          <div className="p-3.5 bg-emerald-50/70 border border-emerald-200/80 rounded-2xl flex items-start gap-2.5 text-xs text-emerald-900">
            <ShieldCheck className="w-5 h-5 text-emerald-600 shrink-0 mt-0.5" />
            <div>
              <strong className="block font-bold">Dilindungi Jaminan Escrow SiswaBantu:</strong>
              <p className="text-[11px] text-emerald-800 mt-0.5 leading-relaxed">
                Wang bayaran anda dipegang dengan selamat di akaun amanah escrow. Penyedia hanya menerima bayaran selepas anda menyemak dan berpuas hati dengan hasil serahan kerja.
              </p>
            </div>
          </div>

          {/* Sistem Rating & Ulasan Mahasiswa */}
          <div className="pt-2 border-t border-slate-100 space-y-3">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-1.5">
                <Star className="w-4 h-4 fill-amber-400 text-amber-400" />
                <h4 className="text-xs font-extrabold text-slate-900">
                  Penarafan & Ulasan ({reviewsCount})
                </h4>
              </div>
              <button
                type="button"
                onClick={() => setShowReviewForm(!showReviewForm)}
                className="text-[11px] font-bold text-indigo-600 hover:text-indigo-800 bg-indigo-50 px-2.5 py-1 rounded-xl transition-all"
              >
                {showReviewForm ? 'Batal' : '+ Tulis Ulasan'}
              </button>
            </div>

            {/* Kotak Ringkasan Penarafan */}
            <div className="p-3 bg-slate-50 rounded-2xl border border-slate-200/70 flex items-center gap-4">
              <div className="text-center shrink-0">
                <span className="text-2xl font-extrabold text-slate-900 block leading-tight">
                  {currentRating.toFixed(1)}
                </span>
                <div className="flex items-center gap-0.5 text-amber-400 justify-center my-0.5">
                  {[1, 2, 3, 4, 5].map((s) => (
                    <Star key={s} className="w-3 h-3 fill-amber-400" />
                  ))}
                </div>
                <span className="text-[9.5px] text-slate-400 font-medium">
                  {reviewsCount} ulasan
                </span>
              </div>
              <div className="flex-1 space-y-1 text-[10px] text-slate-500 font-bold">
                <div className="flex items-center gap-1.5">
                  <span>5★</span>
                  <div className="flex-1 h-1.5 bg-slate-200 rounded-full overflow-hidden">
                    <div className="h-full bg-amber-400 w-[85%] rounded-full"></div>
                  </div>
                </div>
                <div className="flex items-center gap-1.5">
                  <span>4★</span>
                  <div className="flex-1 h-1.5 bg-slate-200 rounded-full overflow-hidden">
                    <div className="h-full bg-amber-400 w-[12%] rounded-full"></div>
                  </div>
                </div>
                <div className="flex items-center gap-1.5">
                  <span>3★</span>
                  <div className="flex-1 h-1.5 bg-slate-200 rounded-full overflow-hidden">
                    <div className="h-full bg-amber-400 w-[3%] rounded-full"></div>
                  </div>
                </div>
              </div>
            </div>

            {/* Borang Tambah Penarafan (Interaktif) */}
            {showReviewForm && (
              <form onSubmit={handleAddReview} className="p-3.5 bg-indigo-50/70 rounded-2xl border border-indigo-200 space-y-2.5 animate-fadeIn">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-slate-800">Pilih Bintang:</span>
                  <div className="flex items-center gap-1">
                    {[1, 2, 3, 4, 5].map((star) => (
                      <button
                        type="button"
                        key={star}
                        onClick={() => setUserRating(star)}
                        className="p-1 hover:scale-110 transition-transform"
                      >
                        <Star
                          className={`w-5 h-5 ${
                            star <= userRating
                              ? 'fill-amber-400 text-amber-400'
                              : 'text-slate-300'
                          }`}
                        />
                      </button>
                    ))}
                  </div>
                </div>
                <textarea
                  required
                  rows={2}
                  value={userComment}
                  onChange={(e) => setUserComment(e.target.value)}
                  placeholder="Kongsi ulasan anda mengenai ketepatan masa, kualiti kerja atau keramahan penyedia..."
                  className="w-full text-xs bg-white border border-slate-200 rounded-xl p-2.5 font-medium outline-none focus:ring-2 focus:ring-indigo-600"
                />
                <button
                  type="submit"
                  className="w-full py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-extrabold text-xs rounded-xl flex items-center justify-center gap-1.5 shadow-sm transition-all"
                >
                  <Send className="w-3.5 h-3.5" />
                  <span>Hantar Penarafan ({userRating} Bintang)</span>
                </button>
              </form>
            )}

            {/* Senarai Ulasan Terkini */}
            <div className="space-y-2">
              {reviewsList.map((rev) => (
                <div key={rev.id} className="p-3 bg-slate-50/80 rounded-2xl border border-slate-100 space-y-1">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-1.5">
                      <span className="text-xs font-extrabold text-slate-900">{rev.name}</span>
                      <span className="text-[9px] bg-emerald-100 text-emerald-800 font-bold px-1.5 py-0.2 rounded">
                        Siswa Sah
                      </span>
                    </div>
                    <div className="flex items-center gap-0.5 text-amber-400">
                      {[...Array(rev.rating)].map((_, i) => (
                        <Star key={i} className="w-3 h-3 fill-amber-400" />
                      ))}
                    </div>
                  </div>
                  <p className="text-xs text-slate-600 leading-relaxed">{rev.comment}</p>
                  <div className="flex items-center justify-between text-[10px] text-slate-400 pt-1">
                    <div className="flex items-center gap-1">
                      {rev.tags.map((t, idx) => (
                        <span key={idx} className="bg-white px-1.5 py-0.5 rounded border border-slate-200 text-slate-500 font-semibold text-[9px]">
                          {t}
                        </span>
                      ))}
                    </div>
                    <span>{rev.date}</span>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Action Button */}
          <div className="pt-2">
            <button
              onClick={() => onBook(service)}
              className="w-full py-3.5 rounded-2xl bg-gradient-to-r from-indigo-600 to-cyan-600 hover:from-indigo-700 hover:to-cyan-700 text-white font-extrabold text-xs shadow-lg shadow-indigo-500/25 active:scale-95 transition-all flex items-center justify-center gap-2"
            >
              <CreditCard className="w-4 h-4" />
              <span>Tempah Sekarang via Escrow ({formatRM(service.price)})</span>
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>

        </div>

      </div>
    </div>
  );
}

