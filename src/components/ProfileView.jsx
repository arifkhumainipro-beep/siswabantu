import React, { useState, useRef } from 'react';
import { 
  User, 
  ShieldCheck, 
  Star, 
  Mail, 
  Phone, 
  School, 
  CreditCard, 
  ToggleLeft, 
  ToggleRight, 
  CheckCircle2, 
  AlertCircle,
  Sparkles,
  Award,
  ChevronRight,
  LogOut,
  Edit3,
  Camera,
  X,
  Plus,
  Briefcase,
  BookOpen,
  Upload
} from 'lucide-react';
import { formatRM } from '../utils/security';
import IPTALogoBadge from './IPTALogoBadge';
import { ALL_IPTA } from '../data/iptaData';

export default function ProfileView({ 
  currentUser, 
  onToggleRole, 
  onOpenEkyc, 
  onOpenWallet,
  onOpenRegister,
  onUpdateUser
}) {
  const isPenyedia = currentUser?.active_role === 'penyedia';
  const [isEditing, setIsEditing] = useState(false);

  // Form states
  const [fullName, setFullName] = useState(currentUser?.full_name || '');
  const [phoneNo, setPhoneNo] = useState(currentUser?.phone_no || '');
  const [college, setCollege] = useState(currentUser?.college || '');
  const [university, setUniversity] = useState(currentUser?.university_name || 'UiTM Shah Alam');
  const [courseName, setCourseName] = useState(currentUser?.course_name || 'Sarjana Muda Sains Komputer');
  const [yearOfStudy, setYearOfStudy] = useState(currentUser?.year_of_study || 'Tahun 3, Semester 2');
  const [bio, setBio] = useState(currentUser?.bio || 'Penyedia servis aktif dan amanah di kolej kediaman.');
  const [avatar, setAvatar] = useState(currentUser?.avatar || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80');
  
  const [skills, setSkills] = useState(currentUser?.skills || ['Runner Kampus ⚡', 'Format Laptop 💻', 'Tutor Akademik 📚']);
  const [newSkill, setNewSkill] = useState('');

  const [experiences, setExperiences] = useState(currentUser?.experiences || [
    'Runner Berlesen Kolej Kediaman (2 Tahun Pengalaman)',
    'Servis Format & Baik Pulih 50+ Komputer Riba Siswa',
    'Tutor Matematik Asas Matrikulasi & SPSS Laporan FYP'
  ]);
  const [newExp, setNewExp] = useState('');

  const presetAvatars = [
    'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=250&q=80',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=250&q=80',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=250&q=80',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=250&q=80',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=250&q=80',
    'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=crop&w=250&q=80',
  ];

  const fileInputRef = useRef(null);

  const handleImageFileChange = (e) => {
    const file = e.target.files?.[0];
    if (file) {
      if (file.size > 5 * 1024 * 1024) {
        alert('Saiz gambar mestilah kurang daripada 5MB');
        return;
      }
      const reader = new FileReader();
      reader.onload = (event) => {
        const base64Url = event.target?.result;
        if (base64Url) {
          setAvatar(base64Url);
          if (onUpdateUser) {
            onUpdateUser({
              ...currentUser,
              avatar: base64Url,
            });
          }
        }
      };
      reader.readAsDataURL(file);
    }
  };

  const handleSaveProfile = (e) => {
    e.preventDefault();
    if (onUpdateUser) {
      onUpdateUser({
        ...currentUser,
        full_name: fullName,
        phone_no: phoneNo,
        college,
        university_name: university,
        course_name: courseName,
        year_of_study: yearOfStudy,
        bio,
        avatar,
        skills,
        experiences,
      });
    }
    setIsEditing(false);
  };

  const handleAddSkill = (e) => {
    e.preventDefault();
    if (newSkill.trim() && !skills.includes(newSkill.trim())) {
      setSkills([...skills, newSkill.trim()]);
      setNewSkill('');
    }
  };

  const handleAddExp = (e) => {
    e.preventDefault();
    if (newExp.trim()) {
      setExperiences([...experiences, newExp.trim()]);
      setNewExp('');
    }
  };

  return (
    <div className="space-y-4 p-3 sm:p-5">
      
      {/* Profil Header Card */}
      <div className="bg-white rounded-3xl p-5 border border-slate-200/90 shadow-sm relative overflow-hidden">
        <div className="absolute top-0 right-0 w-32 h-32 bg-indigo-500/5 rounded-full blur-xl pointer-events-none" />
        
        <div className="flex flex-col sm:flex-row sm:items-center gap-4">
          <input
            type="file"
            ref={fileInputRef}
            accept="image/*"
            onChange={handleImageFileChange}
            className="hidden"
          />
          <div className="relative shrink-0 mx-auto sm:mx-0">
            <img
              src={currentUser?.avatar || avatar}
              alt={currentUser?.full_name}
              className="w-20 h-20 rounded-full object-cover ring-4 ring-selangor-red/25 shadow-md"
            />
            <button
              type="button"
              onClick={() => fileInputRef.current?.click()}
              className="absolute bottom-0 right-0 w-7 h-7 bg-selangor-red hover:bg-selangor-dark text-white rounded-full flex items-center justify-center border-2 border-white shadow-md transition-transform active:scale-90"
              title="Muat Naik Gambar Profil Baru Dari Peranti"
            >
              <Camera className="w-3.5 h-3.5" />
            </button>
          </div>

          <div className="flex-1 min-w-0 text-center sm:text-left">
            <div className="flex flex-wrap items-center justify-center sm:justify-start gap-2">
              <h2 className="text-base sm:text-lg font-extrabold text-slate-900 truncate">
                {currentUser?.full_name}
              </h2>
              {currentUser?.kyc_status === 'Verified' ? (
                <span className="flex items-center gap-1 text-[10px] font-extrabold text-emerald-700 bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded-full">
                  <CheckCircle2 className="w-3 h-3 text-emerald-600" /> Kad Matrik Sah
                </span>
              ) : (
                <span className="text-[10px] font-extrabold text-amber-700 bg-amber-50 border border-amber-200 px-2 py-0.5 rounded-full">
                  e-KYC Belum Lengkap
                </span>
              )}
            </div>

            <div className="mt-1 flex items-center justify-center sm:justify-start gap-2">
              <IPTALogoBadge univ={currentUser?.university_name || 'UiTM'} size="sm" showName={true} />
            </div>

            <p className="text-xs text-slate-500 mt-1">
              {currentUser?.course_name || courseName} • {currentUser?.year_of_study || yearOfStudy}
            </p>

            <div className="flex items-center justify-center sm:justify-start gap-2 mt-2 text-xs text-slate-600">
              <div className="flex items-center gap-1 text-amber-600 font-extrabold">
                <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-400" />
                <span>{currentUser?.rating_avg}</span>
                <span className="text-slate-400 font-normal">({currentUser?.rating_count} ulasan)</span>
              </div>
              <span>•</span>
              <span className="font-mono text-slate-500 text-[11px] font-semibold">{currentUser?.matric_no}</span>
            </div>
          </div>
        </div>

        {/* Butang Kemaskini Profil */}
        <div className="mt-4 pt-3 border-t border-slate-100 flex items-center justify-between gap-2">
          <button
            onClick={() => setIsEditing(true)}
            className="w-full py-2.5 px-4 rounded-2xl bg-indigo-50 hover:bg-indigo-100 border border-indigo-200 text-indigo-700 font-extrabold text-xs flex items-center justify-center gap-1.5 transition-all"
          >
            <Edit3 className="w-3.5 h-3.5" />
            <span>Kemaskini Profil & Pengalaman Siswa</span>
          </button>
        </div>

        {/* FR-1.3 Dwi-Peranan Role Switcher Hero Widget */}
        <div className="mt-4 pt-4 border-t border-slate-100 bg-slate-50/80 -mx-5 -mb-5 p-4 rounded-b-3xl">
          <div className="flex items-center justify-between">
            <div>
              <span className="text-xs font-bold text-slate-900 block">
                Akaun Mahasiswa Bersepadu 🛡️
              </span>
              <p className="text-[11px] text-slate-500 mt-0.5">
                Akses serentak: Tempah servis mahasiswa atau tawarkan servis kemahiran anda bila-bila masa tanpa perlu menukar mod.
              </p>
            </div>

            <div className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-emerald-50 text-emerald-700 border border-emerald-200 text-xs font-extrabold">
              <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" />
              <span>Akses Penuh Aktif</span>
            </div>
          </div>
        </div>
      </div>

      {/* Kad Kemahiran & Pengalaman Siswa */}
      <div className="bg-white rounded-3xl p-5 border border-slate-200/90 shadow-sm space-y-3.5">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Briefcase className="w-4 h-4 text-indigo-600" />
            <h3 className="font-extrabold text-xs text-slate-900 uppercase tracking-wider">
              Kemahiran & Pengalaman Siswa
            </h3>
          </div>
          <button
            onClick={() => setIsEditing(true)}
            className="text-[11px] font-bold text-indigo-600 hover:underline"
          >
            Edit
          </button>
        </div>

        {/* Bio */}
        {currentUser?.bio && (
          <p className="text-xs text-slate-600 bg-slate-50 p-3 rounded-2xl border border-slate-100 leading-relaxed">
            {currentUser.bio}
          </p>
        )}

        {/* Kemahiran */}
        <div>
          <span className="text-[11px] font-bold text-slate-400 block mb-1.5 uppercase">Kemahiran Utama</span>
          <div className="flex flex-wrap gap-1.5">
            {(currentUser?.skills || skills).map((sk, idx) => (
              <span key={idx} className="px-2.5 py-1 bg-indigo-50 border border-indigo-200 text-indigo-700 text-xs font-bold rounded-xl">
                {sk}
              </span>
            ))}
          </div>
        </div>

        {/* Pengalaman */}
        <div>
          <span className="text-[11px] font-bold text-slate-400 block mb-1.5 uppercase">Rekod Khidmat & Pengalaman</span>
          <div className="space-y-1.5">
            {(currentUser?.experiences || experiences).map((exp, idx) => (
              <div key={idx} className="flex items-center gap-2 text-xs text-slate-700 bg-slate-50 p-2.5 rounded-xl border border-slate-100">
                <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0" />
                <span className="font-semibold">{exp}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Maklumat Identiti Pelajar */}
      <div className="bg-white rounded-2xl p-4 border border-slate-200/90 shadow-sm space-y-3">
        <h3 className="font-extrabold text-xs text-slate-900 uppercase tracking-wider">
          Maklumat Rasmi Institusi
        </h3>

        <div className="space-y-2.5 text-xs">
          <div className="flex items-center justify-between py-1.5 border-b border-slate-100">
            <span className="text-slate-500 flex items-center gap-2">
              <Mail className="w-4 h-4 text-slate-400" /> E-mel IPTA (.edu.my)
            </span>
            <strong className="font-mono text-slate-800">{currentUser?.edu_email}</strong>
          </div>

          <div className="flex items-center justify-between py-1.5 border-b border-slate-100">
            <span className="text-slate-500 flex items-center gap-2">
              <CreditCard className="w-4 h-4 text-slate-400" /> Kad Matrik Pelajar
            </span>
            <strong className="font-mono text-slate-800">{currentUser?.matric_no}</strong>
          </div>

          <div className="flex items-center justify-between py-1.5 border-b border-slate-100">
            <span className="text-slate-500 flex items-center gap-2">
              <Phone className="w-4 h-4 text-slate-400" /> No. Telefon
            </span>
            <strong className="text-slate-800">{currentUser?.phone_no}</strong>
          </div>

          <div className="flex items-center justify-between py-1.5">
            <span className="text-slate-500 flex items-center gap-2">
              <School className="w-4 h-4 text-slate-400" /> Kolej Kediaman
            </span>
            <strong className="text-slate-800">{currentUser?.college}</strong>
          </div>
        </div>
      </div>

      {/* Menu Navigasi Tambahan */}
      <div className="bg-white rounded-2xl divide-y divide-slate-100 border border-slate-200/90 shadow-sm overflow-hidden text-xs">
        <button
          onClick={onOpenEkyc}
          className="w-full p-3.5 flex items-center justify-between hover:bg-slate-50 transition-colors"
        >
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-xl bg-emerald-100 text-emerald-700 flex items-center justify-center font-bold">
              <ShieldCheck className="w-4 h-4" />
            </div>
            <div className="text-left">
              <span className="font-bold text-slate-800 block">Pengesahan e-KYC Kad Matrik</span>
              <span className="text-[11px] text-slate-400">Google Cloud Vision OCR</span>
            </div>
          </div>
          <ChevronRight className="w-4 h-4 text-slate-400" />
        </button>

        <button
          onClick={onOpenWallet}
          className="w-full p-3.5 flex items-center justify-between hover:bg-slate-50 transition-colors"
        >
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center font-bold">
              <CreditCard className="w-4 h-4" />
            </div>
            <div className="text-left">
              <span className="font-bold text-slate-800 block">Dompet & Pengeluaran Bank</span>
              <span className="text-[11px] text-slate-400">Baki: {formatRM(currentUser?.wallet_balance || 0)}</span>
            </div>
          </div>
          <ChevronRight className="w-4 h-4 text-slate-400" />
        </button>

        <button
          onClick={onOpenRegister}
          className="w-full p-3.5 flex items-center justify-between hover:bg-slate-50 transition-colors"
        >
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-xl bg-purple-100 text-purple-700 flex items-center justify-center font-bold">
              <Award className="w-4 h-4" />
            </div>
            <div className="text-left">
              <span className="font-bold text-slate-800 block">Daftar Akaun Mahasiswa Baharu</span>
              <span className="text-[11px] text-slate-400">Validasi .edu.my & Simulasi OTP</span>
            </div>
          </div>
          <ChevronRight className="w-4 h-4 text-slate-400" />
        </button>
      </div>

      {/* Modal Edit Profil */}
      {isEditing && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 animate-fadeIn">
          <div className="bg-white rounded-3xl max-w-lg w-full max-h-[90vh] overflow-y-auto p-5 sm:p-6 shadow-2xl border border-slate-200 space-y-4">
            
            <div className="flex items-center justify-between pb-3 border-b border-slate-100">
              <div className="flex items-center gap-2">
                <Edit3 className="w-5 h-5 text-indigo-600" />
                <h3 className="font-extrabold text-slate-900 text-base">Kemaskini Profil & Pengalaman</h3>
              </div>
              <button
                onClick={() => setIsEditing(false)}
                className="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 flex items-center justify-center text-slate-500"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <form onSubmit={handleSaveProfile} className="space-y-4 text-xs">
              
              {/* Gambar Profil */}
              <div className="p-3 bg-slate-50 rounded-2xl border border-slate-200 space-y-3">
                <div className="flex items-center justify-between">
                  <label className="font-bold text-slate-700 block">Pilih Gambar Profil / Avatar:</label>
                  <button
                    type="button"
                    onClick={() => fileInputRef.current?.click()}
                    className="text-[11px] font-extrabold text-selangor-red hover:text-selangor-dark flex items-center gap-1 bg-red-50 hover:bg-red-100 px-2.5 py-1 rounded-xl transition-all border border-red-200"
                  >
                    <Upload className="w-3.5 h-3.5" />
                    <span>Muat Naik Peranti</span>
                  </button>
                </div>

                <div className="flex items-center gap-3">
                  <div className="relative">
                    <img src={avatar} alt="Selected" className="w-14 h-14 rounded-full object-cover ring-2 ring-selangor-red" />
                    <button
                      type="button"
                      onClick={() => fileInputRef.current?.click()}
                      className="absolute -bottom-1 -right-1 w-5 h-5 bg-selangor-red text-white rounded-full flex items-center justify-center border border-white"
                      title="Tukar Gambar"
                    >
                      <Camera className="w-2.5 h-2.5" />
                    </button>
                  </div>
                  <div className="flex-1 overflow-x-auto py-1">
                    <div className="flex gap-2">
                      {presetAvatars.map((url, i) => (
                        <img
                          key={i}
                          src={url}
                          alt={`Preset ${i}`}
                          onClick={() => setAvatar(url)}
                          className={`w-10 h-10 rounded-full object-cover cursor-pointer hover:scale-105 transition-all ${
                            avatar === url ? 'ring-2 ring-selangor-red scale-105' : 'opacity-70'
                          }`}
                        />
                      ))}
                    </div>
                  </div>
                </div>

                <button
                  type="button"
                  onClick={() => fileInputRef.current?.click()}
                  className="w-full py-2.5 px-3 rounded-xl bg-gradient-to-r from-selangor-red to-selangor-dark text-white font-extrabold text-xs flex items-center justify-center gap-2 shadow-sm shadow-selangor-red/25 hover:shadow-selangor-red/40 transition-all"
                >
                  <Upload className="w-4 h-4" />
                  <span>Pilih & Muat Naik Gambar dari Komputer / Peranti (JPG / PNG)</span>
                </button>

                <input
                  type="text"
                  value={avatar}
                  onChange={(e) => setAvatar(e.target.value)}
                  placeholder="Atau tampal URL pautan gambar sendiri..."
                  className="w-full text-xs bg-white border border-slate-200 rounded-xl p-2 font-medium outline-none focus:ring-2 focus:ring-selangor-red"
                />
              </div>

              {/* Nama & Telefon */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="font-bold text-slate-700 block mb-1">Nama Penuh Siswa:</label>
                  <input
                    type="text"
                    required
                    value={fullName}
                    onChange={(e) => setFullName(e.target.value)}
                    className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-bold outline-none focus:ring-2 focus:ring-indigo-600"
                  />
                </div>
                <div>
                  <label className="font-bold text-slate-700 block mb-1">No. Telefon WhatsApp:</label>
                  <input
                    type="text"
                    required
                    value={phoneNo}
                    onChange={(e) => setPhoneNo(e.target.value)}
                    className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-bold outline-none focus:ring-2 focus:ring-indigo-600"
                  />
                </div>
              </div>

              {/* Universiti & Kolej */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="font-bold text-slate-700 block mb-1">Universiti Awam (IPTA):</label>
                  <select
                    value={university}
                    onChange={(e) => setUniversity(e.target.value)}
                    className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-bold outline-none focus:ring-2 focus:ring-indigo-600"
                  >
                    {ALL_IPTA.map((ipta) => (
                      <option key={ipta.id} value={`${ipta.fullName} (${ipta.code})`}>
                        {ipta.code} - {ipta.shortName}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="font-bold text-slate-700 block mb-1">Kolej Kediaman / Bilik:</label>
                  <input
                    type="text"
                    required
                    value={college}
                    onChange={(e) => setCollege(e.target.value)}
                    className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-bold outline-none focus:ring-2 focus:ring-indigo-600"
                  />
                </div>
              </div>

              {/* Kursus & Tahun Pengajian */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="font-bold text-slate-700 block mb-1">Bidang / Kursus Pengajian:</label>
                  <input
                    type="text"
                    value={courseName}
                    onChange={(e) => setCourseName(e.target.value)}
                    placeholder="Cth: Sarjana Muda Sains Komputer"
                    className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-bold outline-none focus:ring-2 focus:ring-indigo-600"
                  />
                </div>
                <div>
                  <label className="font-bold text-slate-700 block mb-1">Tahun & Semester:</label>
                  <input
                    type="text"
                    value={yearOfStudy}
                    onChange={(e) => setYearOfStudy(e.target.value)}
                    placeholder="Cth: Tahun 3, Semester 2"
                    className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-bold outline-none focus:ring-2 focus:ring-indigo-600"
                  />
                </div>
              </div>

              {/* Bio */}
              <div>
                <label className="font-bold text-slate-700 block mb-1">Bio / Pengenalan Diri:</label>
                <textarea
                  rows={2}
                  value={bio}
                  onChange={(e) => setBio(e.target.value)}
                  className="w-full text-xs bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-medium outline-none focus:ring-2 focus:ring-indigo-600"
                />
              </div>

              {/* Kemahiran */}
              <div className="p-3 bg-indigo-50/50 rounded-2xl border border-indigo-100 space-y-2">
                <label className="font-bold text-indigo-900 block">Kemahiran Utama:</label>
                <div className="flex flex-wrap gap-1.5">
                  {skills.map((sk, idx) => (
                    <span key={idx} className="flex items-center gap-1 bg-white px-2 py-0.5 rounded-lg border border-indigo-200 text-indigo-700 font-bold text-[11px]">
                      {sk}
                      <button type="button" onClick={() => setSkills(skills.filter((_, i) => i !== idx))}>
                        <X className="w-3 h-3 text-indigo-400 hover:text-red-500" />
                      </button>
                    </span>
                  ))}
                </div>
                <div className="flex gap-2">
                  <input
                    type="text"
                    value={newSkill}
                    onChange={(e) => setNewSkill(e.target.value)}
                    placeholder="Tambah kemahiran..."
                    className="flex-1 text-xs bg-white border border-indigo-200 rounded-xl p-2 outline-none"
                  />
                  <button
                    type="button"
                    onClick={handleAddSkill}
                    className="px-3 py-1 bg-indigo-600 text-white rounded-xl font-bold"
                  >
                    Tambah
                  </button>
                </div>
              </div>

              {/* Pengalaman */}
              <div className="p-3 bg-emerald-50/50 rounded-2xl border border-emerald-100 space-y-2">
                <label className="font-bold text-emerald-900 block">Pengalaman Kerja & Servis:</label>
                <div className="space-y-1.5">
                  {experiences.map((exp, idx) => (
                    <div key={idx} className="flex items-center justify-between bg-white p-2 rounded-xl border border-emerald-100 text-[11px] font-semibold text-slate-700">
                      <span>{exp}</span>
                      <button type="button" onClick={() => setExperiences(experiences.filter((_, i) => i !== idx))}>
                        <X className="w-3 h-3 text-red-500" />
                      </button>
                    </div>
                  ))}
                </div>
                <div className="flex gap-2">
                  <input
                    type="text"
                    value={newExp}
                    onChange={(e) => setNewExp(e.target.value)}
                    placeholder="Cth: Runner Makanan (1 Tahun), Format 30 Laptop..."
                    className="flex-1 text-xs bg-white border border-emerald-200 rounded-xl p-2 outline-none"
                  />
                  <button
                    type="button"
                    onClick={handleAddExp}
                    className="px-3 py-1 bg-emerald-600 text-white rounded-xl font-bold"
                  >
                    Tambah
                  </button>
                </div>
              </div>

              {/* Submit */}
              <button
                type="submit"
                className="w-full py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-extrabold text-xs rounded-xl shadow-md transition-all"
              >
                Simpan Perubahan Profil & Pengalaman 💾
              </button>
            </form>

          </div>
        </div>
      )}

    </div>
  );
}

