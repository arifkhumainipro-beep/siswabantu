import React, { useState } from 'react';
import confetti from 'canvas-confetti';
import { Store, Flame, ClipboardList, Wallet, User } from 'lucide-react';
import Header from './components/Header';
import AuthPage from './components/AuthPage';
import MarketplaceView from './components/MarketplaceView';
import BantuSOSView from './components/BantuSOSView';
import OrderManagementView from './components/OrderManagementView';
import WalletView from './components/WalletView';
import ProfileView from './components/ProfileView';
import ServiceDetailModal from './components/ServiceDetailModal';
import CreateServiceModal from './components/CreateServiceModal';
import ChatModal from './components/ChatModal';
import FpxModal from './components/FpxModal';
import DisputeModal from './components/DisputeModal';
import ReviewModal from './components/ReviewModal';
import EkycModal from './components/EkycModal';
import AdminDashboard from './components/AdminDashboard';

import { 
  INITIAL_USERS, 
  INITIAL_SERVICES, 
  INITIAL_SOS_REQUESTS, 
  INITIAL_ORDERS, 
  INITIAL_CHATS, 
  INITIAL_DISPUTES 
} from './data/mockData';
import { calculateEscrowSplit, formatRM } from './utils/security';

export default function App() {
  // Authentication State: null means on Login/Register page!
  // { role: 'siswa' | 'admin', user: ... }
  const [authSession, setAuthSession] = useState(null);

  // Global Data States
  const [currentUser, setCurrentUser] = useState(INITIAL_USERS[0]);
  const [users, setUsers] = useState(INITIAL_USERS);
  const [services, setServices] = useState(INITIAL_SERVICES);
  const [sosRequests, setSosRequests] = useState(INITIAL_SOS_REQUESTS);
  const [orders, setOrders] = useState(INITIAL_ORDERS);
  const [chats, setChats] = useState(INITIAL_CHATS);
  const [disputes, setDisputes] = useState(INITIAL_DISPUTES);

  // Active Tab for Student Portal
  const [activeTab, setActiveTab] = useState('explore'); // explore | sos | orders | wallet | profile
  const [toastMessage, setToastMessage] = useState(null);

  // Modals
  const [selectedService, setSelectedService] = useState(null);
  const [showCreateService, setShowCreateService] = useState(false);
  const [activeChatOrder, setActiveChatOrder] = useState(null);
  const [activeFpxOrder, setActiveFpxOrder] = useState(null);
  const [activeDisputeOrder, setActiveDisputeOrder] = useState(null);
  const [activeReviewOrder, setActiveReviewOrder] = useState(null);
  const [showEkycModal, setShowEkycModal] = useState(false);

  const showToast = (msg, type = 'info') => {
    setToastMessage({ text: msg, type });
    setTimeout(() => {
      setToastMessage(null);
    }, 4000);
  };

  // Auth Handlers
  const handleLoginSiswa = (user) => {
    setCurrentUser(user);
    setAuthSession({ role: 'siswa', user });
    showToast(`Selamat datang ${user.full_name}! Berjaya log masuk ke Portal Siswa.`, 'success');
  };

  const handleRegisterSiswa = (newUser) => {
    setUsers([...users, newUser]);
    setCurrentUser(newUser);
    setAuthSession({ role: 'siswa', user: newUser });
    showToast(`Pendaftaran berjaya! E-mel ${newUser.edu_email} telah disahkan (.edu.my).`, 'success');
  };

  const handleLoginAdmin = (adminUser) => {
    setAuthSession({ role: 'admin', user: adminUser });
    showToast(`Log masuk Pentadbir disahkan. Selamat datang ke Pusat Kawalan SiswaBantu.`, 'success');
  };

  const handleLogout = () => {
    setAuthSession(null);
    showToast('Anda telah log keluar daripada sistem.', 'info');
  };

  // Role Switcher (Pemohon <-> Penyedia)
  const handleToggleRole = (newRole) => {
    setCurrentUser(prev => ({
      ...prev,
      active_role: newRole
    }));
    showToast(`Beralih ke Mod ${newRole === 'penyedia' ? 'Penyedia Bantu' : 'Pemohon Bantu'}`, 'success');
  };

  // Tempah Servis (FR-3.1)
  const handleBookService = (service) => {
    setSelectedService(null);

    const split = calculateEscrowSplit(service.price);
    const newOrder = {
      order_id: `ORD-2026-${Math.floor(100 + Math.random() * 900)}`,
      service_id: service.service_id,
      service_title: service.title,
      category: service.category,
      buyer_id: currentUser.user_id,
      buyer_name: currentUser.full_name,
      provider_id: service.provider_id,
      provider_name: service.provider_name,
      total_amount: service.price,
      commission_fee: split.commissionFee,
      net_amount: split.netEarnings,
      escrow_status: 'Pending',
      order_status: 'MENUNGGU_BAYARAN',
      proof_file_url: null,
      created_at: new Date().toISOString().replace('T', ' ').slice(0, 16),
      delivery_note: 'Pesanan baharu melalui platform SiswaBantu.',
      auto_cancel_hours_left: 24,
    };

    setOrders([newOrder, ...orders]);
    setActiveFpxOrder(newOrder);
  };

  // Bayaran FPX Berjaya (FR-4.1 & TC-ESC-01)
  const handleFpxSuccess = (orderId) => {
    setOrders(prev => prev.map(o => {
      if (o.order_id === orderId) {
        return {
          ...o,
          order_status: 'MENUNGGU_TERIMA',
          escrow_status: 'Held'
        };
      }
      return o;
    }));

    setCurrentUser(prev => ({
      ...prev,
      escrow_balance: (prev.escrow_balance || 0) + (orders.find(o => o.order_id === orderId)?.total_amount || 0)
    }));

    showToast(`Bayaran Escrow berjaya! Menunggu penerimaan penyedia (24j SLA).`, 'success');
    setActiveTab('orders');
  };

  // Order State Machine (FR-3.1 & FR-4.2)
  const handleUpdateOrderStatus = (orderId, nextStatus, payload = {}) => {
    const targetOrder = orders.find(o => o.order_id === orderId);
    if (!targetOrder) return;

    if (nextStatus === 'SELESAI') {
      const split = calculateEscrowSplit(targetOrder.total_amount);

      setOrders(prev => prev.map(o => {
        if (o.order_id === orderId) {
          return {
            ...o,
            order_status: 'SELESAI',
            escrow_status: 'Released'
          };
        }
        return o;
      }));

      setCurrentUser(prev => ({
        ...prev,
        wallet_balance: prev.wallet_balance + split.netEarnings,
        escrow_balance: Math.max(0, prev.escrow_balance - targetOrder.total_amount)
      }));

      confetti({
        particleCount: 80,
        spread: 60,
        origin: { y: 0.7 }
      });

      showToast(`Tugasan selesai! ${formatRM(split.netEarnings)} (95%) dimasukkan ke baki dompet. Komisen 5% (${formatRM(split.commissionFee)}) dipotong.`, 'success');
      return;
    }

    if (nextStatus === 'DIBATALKAN' && payload.autoCancel) {
      setOrders(prev => prev.map(o => {
        if (o.order_id === orderId) {
          return {
            ...o,
            order_status: 'DIBATALKAN',
            escrow_status: 'Refunded'
          };
        }
        return o;
      }));

      setCurrentUser(prev => ({
        ...prev,
        wallet_balance: prev.wallet_balance + targetOrder.total_amount,
        escrow_balance: Math.max(0, prev.escrow_balance - targetOrder.total_amount)
      }));

      showToast(`Pesanan dibatalkan (24j tamat). Wang ${formatRM(targetOrder.total_amount)} dipulangkan 100% ke baki Pemohon.`, 'info');
      return;
    }

    if (nextStatus === 'MENUNGGU_PENGESAHAN') {
      setOrders(prev => prev.map(o => {
        if (o.order_id === orderId) {
          return {
            ...o,
            order_status: 'MENUNGGU_PENGESAHAN',
            proof_file_url: payload.proofUrl || 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&w=800&q=80'
          };
        }
        return o;
      }));
      showToast(`Bukti kerja siap berjaya dimuat naik. Menunggu pengesahan Pemohon.`, 'success');
      return;
    }

    setOrders(prev => prev.map(o => o.order_id === orderId ? { ...o, order_status: nextStatus } : o));
    showToast(`Status pesanan dikemas kini ke ${nextStatus}`, 'info');
  };

  // Pertikaian Escrow (FR-5.2)
  const handleSubmitDispute = (disputeData) => {
    setDisputes([disputeData, ...disputes]);
    setOrders(prev => prev.map(o => o.order_id === disputeData.order_id ? { ...o, order_status: 'PERTIKAIAN', escrow_status: 'Frozen' } : o));
    showToast(`Pertikaian dibuka! Dana Escrow bernilai ${formatRM(disputeData.amount)} dibekukan serta-merta.`, 'warning');
  };

  const handleResolveDispute = (disputeId, resolutionType) => {
    const dsp = disputes.find(d => d.dispute_id === disputeId);
    if (!dsp) return;

    let resolutionText = '';
    if (resolutionType === 'refund_100') {
      resolutionText = 'Pulangkan 100% wang kepada Pemohon';
      setOrders(prev => prev.map(o => o.order_id === dsp.order_id ? { ...o, escrow_status: 'Refunded', order_status: 'DIBATALKAN' } : o));
    } else if (resolutionType === 'release_100') {
      resolutionText = 'Lepaskan 100% wang kepada Penyedia';
      setOrders(prev => prev.map(o => o.order_id === dsp.order_id ? { ...o, escrow_status: 'Released', order_status: 'SELESAI' } : o));
    } else if (resolutionType === 'split_50_50') {
      resolutionText = 'Pembahagian Separa 50/50';
      setOrders(prev => prev.map(o => o.order_id === dsp.order_id ? { ...o, escrow_status: 'Split50', order_status: 'SELESAI' } : o));
    }

    setDisputes(prev => prev.map(d => d.dispute_id === disputeId ? { ...d, status: 'Resolved', admin_resolution: resolutionText } : d));
    showToast(`Keputusan Admin: ${resolutionText}`, 'success');
  };

  // Servis Baharu (FR-2.1)
  const handleSaveNewService = (newService) => {
    setServices([newService, ...services]);
    showToast(`Servis baharu diterbitkan!`, 'success');
  };

  // Bantu SOS (FR-2.3)
  const handlePostSOS = (newSOS) => {
    const created = {
      sos_id: `sos-${Date.now()}`,
      ...newSOS,
      created_at: 'Baru sahaja',
      status: 'OPEN',
      offers_count: 0
    };
    setSosRequests([created, ...sosRequests]);
    showToast(`Permintaan Bantu SOS telah disiarkan!`, 'success');
  };

  // Pengeluaran Wang (FR-4.3)
  const handleWithdraw = (amount) => {
    setCurrentUser(prev => ({
      ...prev,
      wallet_balance: Math.max(0, prev.wallet_balance - amount)
    }));
  };

  // e-KYC (FR-1.2)
  const handleEkycVerified = (ocrData) => {
    setCurrentUser(prev => ({
      ...prev,
      kyc_status: 'Verified',
      matric_no: ocrData.matric_no
    }));
    showToast(`e-KYC Kad Matrik ${ocrData.matric_no} disahkan!`, 'success');
  };

  // Render content according to active tab
  const renderStudentContent = () => {
    switch (activeTab) {
      case 'explore':
        return (
          <MarketplaceView
            services={services}
            onSelectService={setSelectedService}
            onBookService={handleBookService}
            onStartChatWithProvider={(srv) => {
              const matchedOrder = orders.find(o => o.service_id === srv.service_id) || orders[0];
              setActiveChatOrder(matchedOrder);
            }}
            activeRole={currentUser.active_role}
            currentUser={currentUser}
            onToggleRole={handleToggleRole}
            onAddService={() => setShowCreateService(true)}
          />
        );
      case 'sos':
        return (
          <BantuSOSView
            sosRequests={sosRequests}
            onPostSOS={handlePostSOS}
            onOfferHelp={(sos) => showToast(`Tawaran bantuan dihantar kepada ${sos.buyer_name}!`, 'success')}
            currentUser={currentUser}
          />
        );
      case 'orders':
        return (
          <OrderManagementView
            orders={orders}
            onUpdateOrderStatus={handleUpdateOrderStatus}
            onOpenChat={setActiveChatOrder}
            onOpenDispute={setActiveDisputeOrder}
            onOpenFpx={setActiveFpxOrder}
            onOpenReview={setActiveReviewOrder}
            activeRole={currentUser.active_role}
          />
        );
      case 'wallet':
        return (
          <WalletView
            currentUser={currentUser}
            onWithdraw={handleWithdraw}
            orders={orders}
          />
        );
      case 'profile':
        return (
          <ProfileView
            currentUser={currentUser}
            onToggleRole={handleToggleRole}
            onOpenEkyc={() => setShowEkycModal(true)}
            onOpenWallet={() => setActiveTab('wallet')}
            onOpenRegister={() => setAuthSession(null)}
          />
        );
      default:
        return null;
    }
  };

  // IF NOT LOGGED IN: Render Unified Auth Page (Login Siswa, Daftar .edu.my, Login Admin)
  if (!authSession) {
    return (
      <div className="font-sans antialiased">
        {toastMessage && (
          <div className="fixed top-5 right-5 z-50 max-w-sm bg-slate-900 text-white p-3.5 rounded-2xl shadow-2xl border border-slate-700 flex items-center gap-3 animate-slideDown">
            <div className="w-2.5 h-2.5 rounded-full bg-selangor-yellow animate-ping" />
            <p className="text-xs font-semibold leading-relaxed flex-1">{toastMessage.text}</p>
          </div>
        )}
        <AuthPage
          onLoginSiswa={handleLoginSiswa}
          onLoginAdmin={handleLoginAdmin}
          onRegisterSiswa={handleRegisterSiswa}
          users={users}
        />
      </div>
    );
  }

  // IF LOGGED IN: Render Complete Web System
  return (
    <div className="min-h-screen bg-gradient-to-b from-slate-50 via-slate-100/70 to-slate-100 text-slate-800 flex flex-col font-sans selection:bg-selangor-red selection:text-white">
      
      {/* Toast Alert */}
      {toastMessage && (
        <div className="fixed top-20 right-4 z-50 max-w-sm bg-slate-900/95 backdrop-blur-md text-white p-3.5 rounded-2xl shadow-2xl border border-slate-700 flex items-center gap-3 animate-slideDown">
          <div className="w-2.5 h-2.5 rounded-full bg-cyan-400 animate-ping" />
          <p className="text-xs font-semibold leading-relaxed flex-1">{toastMessage.text}</p>
        </div>
      )}

      {/* Main Header with Navigation & Logout */}
      <Header
        currentUser={currentUser}
        authRole={authSession.role}
        onToggleRole={handleToggleRole}
        activeTab={activeTab}
        setActiveTab={setActiveTab}
        onLogout={handleLogout}
        onOpenWallet={() => setActiveTab('wallet')}
        onOpenEkyc={() => setShowEkycModal(true)}
        onAddService={() => setShowCreateService(true)}
        ordersCount={orders.filter(o => ['MENUNGGU_BAYARAN', 'MENUNGGU_TERIMA', 'SEDANG_DILAKUKAN'].includes(o.order_status)).length}
        sosCount={sosRequests.length}
      />

      {/* Main Body */}
      <main className="flex-1 max-w-7xl w-full mx-auto py-6 px-4 sm:px-6 lg:px-8">
        {authSession.role === 'admin' ? (
          <AdminDashboard
            disputes={disputes}
            onResolveDispute={handleResolveDispute}
            orders={orders}
            users={users}
          />
        ) : (
          renderStudentContent()
        )}
      </main>

      {/* Enterprise Platform Footer */}
      <footer className="mt-auto border-t border-slate-200/80 bg-white/70 backdrop-blur-md py-6 px-4">
        <div className="max-w-7xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-3 text-xs text-slate-500">
          <div className="flex items-center gap-2">
            <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
            <span className="font-bold text-slate-800">SiswaBantu Ecosystem</span>
            <span>• Komuniti Rasmi 21 IPTA Malaysia</span>
          </div>
          <div className="flex items-center gap-4 text-[11px]">
            <span>100% Escrow Protection</span>
            <span>•</span>
            <span>e-KYC Verified (.edu.my)</span>
            <span>•</span>
            <span className="font-mono text-selangor-red font-bold">IEEE Std 829/830 Certified</span>
          </div>
        </div>
      </footer>

      {/* Dribbble-Style Floating Bottom Dock (Mobile) */}
      {authSession.role === 'siswa' && (
        <div className="fixed bottom-3 left-1/2 -translate-x-1/2 z-40 bg-white/95 backdrop-blur-md rounded-full shadow-2xl border border-slate-200/90 px-3 py-1.5 flex items-center gap-1.5 sm:hidden">
          <button
            onClick={() => setActiveTab('explore')}
            className={`flex flex-col items-center px-3 py-1.5 rounded-full transition-all ${
              activeTab === 'explore'
                ? 'bg-selangor-red text-white shadow-md shadow-selangor-red/30 font-extrabold'
                : 'text-slate-500 hover:text-slate-900 font-semibold'
            }`}
          >
            <Store className="w-4 h-4" />
            <span className="text-[9.5px]">Katalog</span>
          </button>

          <button
            onClick={() => setActiveTab('sos')}
            className={`flex flex-col items-center px-3 py-1.5 rounded-full transition-all relative ${
              activeTab === 'sos'
                ? 'bg-rose-500 text-white shadow-md shadow-rose-500/30 font-extrabold'
                : 'text-rose-500 hover:text-rose-600 font-semibold'
            }`}
          >
            <Flame className="w-4 h-4" />
            <span className="text-[9.5px]">SOS</span>
            {sosRequests.length > 0 && (
              <span className="absolute -top-1 -right-1 w-2 h-2 rounded-full bg-rose-500 animate-ping" />
            )}
          </button>

          <button
            onClick={() => setActiveTab('orders')}
            className={`flex flex-col items-center px-3 py-1.5 rounded-full transition-all relative ${
              activeTab === 'orders'
                ? 'bg-selangor-red text-white shadow-md shadow-selangor-red/30 font-extrabold'
                : 'text-slate-500 hover:text-slate-900 font-semibold'
            }`}
          >
            <ClipboardList className="w-4 h-4" />
            <span className="text-[9.5px]">Pesanan</span>
            {orders.length > 0 && (
              <span className="absolute -top-1 -right-1 px-1 py-0.2 rounded-full bg-selangor-red text-white text-[8px] font-bold">
                {orders.length}
              </span>
            )}
          </button>

          <button
            onClick={() => setActiveTab('wallet')}
            className={`flex flex-col items-center px-3 py-1.5 rounded-full transition-all ${
              activeTab === 'wallet'
                ? 'bg-selangor-red text-white shadow-md shadow-selangor-red/30 font-extrabold'
                : 'text-slate-500 hover:text-slate-900 font-semibold'
            }`}
          >
            <Wallet className="w-4 h-4" />
            <span className="text-[9.5px]">Dompet</span>
          </button>

          <button
            onClick={() => setActiveTab('profile')}
            className={`flex flex-col items-center px-3 py-1.5 rounded-full transition-all ${
              activeTab === 'profile'
                ? 'bg-selangor-red text-white shadow-md shadow-selangor-red/30 font-extrabold'
                : 'text-slate-500 hover:text-slate-900 font-semibold'
            }`}
          >
            <User className="w-4 h-4" />
            <span className="text-[9.5px]">Profil</span>
          </button>
        </div>
      )}

      {/* Modals */}
      <ServiceDetailModal
        service={selectedService}
        onClose={() => setSelectedService(null)}
        onBook={handleBookService}
        onChat={(srv) => {
          const matched = orders.find(o => o.service_id === srv.service_id) || orders[0];
          setSelectedService(null);
          setActiveChatOrder(matched);
        }}
      />

      <CreateServiceModal
        isOpen={showCreateService}
        onClose={() => setShowCreateService(false)}
        onSaveService={handleSaveNewService}
        currentUser={currentUser}
      />

      {activeChatOrder && (
        <ChatModal
          order={activeChatOrder}
          currentUser={currentUser}
          initialChats={chats[activeChatOrder.order_id] || [
            {
              id: 'init-1',
              sender_id: activeChatOrder.provider_id,
              sender_name: activeChatOrder.provider_name,
              text: `Hai ${currentUser.full_name}, pesanan anda telah diterima. Ada maklumat tambahan?`,
              timestamp: '10:00',
              is_warning: false
            }
          ]}
          onSendMessage={(orderId, updatedMsgs) => {
            setChats(prev => ({ ...prev, [orderId]: updatedMsgs }));
          }}
          onClose={() => setActiveChatOrder(null)}
        />
      )}

      {activeFpxOrder && (
        <FpxModal
          order={activeFpxOrder}
          onClose={() => setActiveFpxOrder(null)}
          onSuccessPayment={handleFpxSuccess}
        />
      )}

      {activeDisputeOrder && (
        <DisputeModal
          order={activeDisputeOrder}
          onClose={() => setActiveDisputeOrder(null)}
          onSubmitDispute={handleSubmitDispute}
        />
      )}

      {activeReviewOrder && (
        <ReviewModal
          order={activeReviewOrder}
          onClose={() => setActiveReviewOrder(null)}
          onSubmitReview={() => showToast('Terima kasih atas ulasan dan penarafan anda!', 'success')}
        />
      )}

      {showEkycModal && (
        <EkycModal
          currentUser={currentUser}
          onClose={() => setShowEkycModal(false)}
          onVerified={handleEkycVerified}
        />
      )}

    </div>
  );
}
