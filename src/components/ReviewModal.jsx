import React, { useState } from 'react';
import { Star, ThumbsUp, X, Sparkles, CheckCircle2 } from 'lucide-react';

const TAGS = [
  'Pantas & Tepat Waktu ⚡',
  'Sopan & Amanah 🤝',
  'Hasil Berkualiti Tinggi 🌟',
  'Sangat Memuaskan 💯',
  'Komunikasi Jelas 💬'
];

export default function ReviewModal({ order, onClose, onSubmitReview }) {
  const [rating, setRating] = useState(5);
  const [comment, setComment] = useState('Servis terbaik! Runner sangat laju dan peramah. Memang recommended!');
  const [selectedTags, setSelectedTags] = useState(['Pantas & Tepat Waktu ⚡', 'Sopan & Amanah 🤝']);

  if (!order) return null;

  const toggleTag = (tag) => {
    if (selectedTags.includes(tag)) {
      setSelectedTags(selectedTags.filter(t => t !== tag));
    } else {
      setSelectedTags([...selectedTags, tag]);
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onSubmitReview({
      order_id: order.order_id,
      rating,
      comment,
      tags: selectedTags,
    });
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 animate-fadeIn">
      <div className="bg-white rounded-3xl max-w-md w-full p-5 sm:p-6 shadow-2xl border border-slate-200 space-y-4">
        
        {/* Header */}
        <div className="flex justify-between items-center pb-2 border-b border-slate-100">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-xl bg-amber-100 text-amber-700 flex items-center justify-center">
              <Star className="w-4 h-4 fill-amber-400 text-amber-500" />
            </div>
            <div>
              <h3 className="font-extrabold text-sm sm:text-base text-slate-900">
                Penilaian & Ulasan Dua Hala (FR-5.1)
              </h3>
              <p className="text-[11px] text-slate-500 font-medium">
                Bina Reputasi Komuniti Kampus yang Dipercayai
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

        <form onSubmit={handleSubmit} className="space-y-4 text-center">
          <div>
            <p className="text-xs text-slate-600 mb-2">
              Bagaimanakah pengalaman anda berurusan dengan <strong>{order.provider_name}</strong>?
            </p>

            {/* Bintang Penarafan */}
            <div className="flex justify-center items-center gap-2 py-1">
              {[1, 2, 3, 4, 5].map((star) => (
                <button
                  type="button"
                  key={star}
                  onClick={() => setRating(star)}
                  className="p-1 hover:scale-125 transition-transform"
                >
                  <Star
                    className={`w-8 h-8 ${
                      star <= rating
                        ? 'fill-amber-400 text-amber-400 drop-shadow-sm'
                        : 'text-slate-200'
                    }`}
                  />
                </button>
              ))}
            </div>
            <span className="text-xs font-bold text-amber-700 block mt-1">
              {rating === 5 ? 'Cemerlang! (5.0)' : rating === 4 ? 'Sangat Baik (4.0)' : `${rating}.0 Bintang`}
            </span>
          </div>

          {/* Tag Pujian */}
          <div className="text-left">
            <label className="text-[11px] font-bold text-slate-700 block mb-1.5">
              Pilih Tag Pujian Komuniti:
            </label>
            <div className="flex flex-wrap gap-1.5">
              {TAGS.map((tag) => {
                const isSelected = selectedTags.includes(tag);
                return (
                  <button
                    type="button"
                    key={tag}
                    onClick={() => toggleTag(tag)}
                    className={`px-2.5 py-1 rounded-full text-[11px] font-bold transition-all ${
                      isSelected
                        ? 'bg-indigo-600 text-white shadow-sm shadow-indigo-500/20'
                        : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
                    }`}
                  >
                    {tag}
                  </button>
                );
              })}
            </div>
          </div>

          {/* Ulasan Teks */}
          <div className="text-left">
            <label className="text-[11px] font-bold text-slate-700 block mb-1">
              Ulasan Anda:
            </label>
            <textarea
              rows={3}
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-medium outline-none focus:ring-2 focus:ring-indigo-600"
            />
          </div>

          <button
            type="submit"
            className="w-full py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-extrabold text-xs shadow-md shadow-indigo-500/20 active:scale-95 transition-all flex items-center justify-center gap-1.5"
          >
            <CheckCircle2 className="w-4 h-4" />
            <span>Hantar Penarafan Bintang</span>
          </button>
        </form>

      </div>
    </div>
  );
}

