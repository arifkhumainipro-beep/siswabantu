class UserModel {
  final String userId;
  String fullName;
  final String eduEmail;
  String phoneNo;
  String universityName;
  final String matricNo;
  String kycStatus; // 'Verified', 'Pending', 'Rejected'
  double walletBalance;
  double escrowBalance;
  final double ratingAvg;
  final int ratingCount;
  String activeRole; // 'pemohon', 'penyedia'
  String avatar;
  String college;
  String bio;
  String courseName;
  String yearOfStudy;
  List<String> skills;
  List<String> experiences;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.eduEmail,
    required this.phoneNo,
    required this.universityName,
    required this.matricNo,
    this.kycStatus = 'Pending',
    this.walletBalance = 0.0,
    this.escrowBalance = 0.0,
    this.ratingAvg = 5.0,
    this.ratingCount = 0,
    this.activeRole = 'pemohon',
    required this.avatar,
    required this.college,
    this.bio = '',
    this.courseName = 'Ijazah Sarjana Muda',
    this.yearOfStudy = 'Tahun 2, Semester 1',
    List<String>? skills,
    List<String>? experiences,
  })  : skills = skills ?? ['Runner Kampus ⚡', 'Format Laptop 💻', 'Tutor Akademik 📚'],
        experiences = experiences ?? [
          'Runner Berlesen Kolej Kediaman (2 Tahun Pengalaman)',
          'Servis Format & Optimasi SSD Komputer Riba Mahasiswa',
          'Tutor Matematik Asas Matrikulasi & SPSS Laporan FYP',
        ];

  UserModel copyWith({
    String? fullName,
    String? phoneNo,
    String? universityName,
    String? avatar,
    String? college,
    String? bio,
    String? courseName,
    String? yearOfStudy,
    List<String>? skills,
    List<String>? experiences,
    String? activeRole,
    String? kycStatus,
    double? walletBalance,
    double? escrowBalance,
  }) {
    return UserModel(
      userId: userId,
      fullName: fullName ?? this.fullName,
      eduEmail: eduEmail,
      phoneNo: phoneNo ?? this.phoneNo,
      universityName: universityName ?? this.universityName,
      matricNo: matricNo,
      kycStatus: kycStatus ?? this.kycStatus,
      walletBalance: walletBalance ?? this.walletBalance,
      escrowBalance: escrowBalance ?? this.escrowBalance,
      ratingAvg: ratingAvg,
      ratingCount: ratingCount,
      activeRole: activeRole ?? this.activeRole,
      avatar: avatar ?? this.avatar,
      college: college ?? this.college,
      bio: bio ?? this.bio,
      courseName: courseName ?? this.courseName,
      yearOfStudy: yearOfStudy ?? this.yearOfStudy,
      skills: skills ?? List.from(this.skills),
      experiences: experiences ?? List.from(this.experiences),
    );
  }
}

class ServiceReview {
  final String reviewId;
  final String reviewerName;
  final String reviewerAvatar;
  final String reviewerMatric;
  final String university;
  final double rating;
  final String comment;
  final List<String> tags;
  final String date;

  ServiceReview({
    required this.reviewId,
    required this.reviewerName,
    required this.reviewerAvatar,
    required this.reviewerMatric,
    required this.university,
    required this.rating,
    required this.comment,
    this.tags = const [],
    required this.date,
  });
}

class ServiceModel {
  final String serviceId;
  final String providerId;
  final String providerName;
  final String providerAvatar;
  final String providerMatric;
  final String university;
  final String college;
  final String title;
  final String category;
  final String categoryName;
  final String description;
  final double price;
  final String priceType;
  final String slaHours;
  final bool providerKyc;
  double rating;
  int reviewsCount;
  final List<String> images;
  final bool isActive;
  final bool isOnline;
  final List<ServiceReview> reviews;

  ServiceModel({
    required this.serviceId,
    required this.providerId,
    required this.providerName,
    required this.providerAvatar,
    required this.providerMatric,
    this.providerKyc = true,
    required this.university,
    required this.college,
    required this.title,
    required this.category,
    required this.categoryName,
    required this.description,
    required this.price,
    this.priceType = 'Tetap',
    required this.slaHours,
    this.rating = 5.0,
    this.reviewsCount = 0,
    required this.images,
    this.isActive = true,
    this.isOnline = true,
    List<ServiceReview>? reviews,
  }) : reviews = reviews ?? [];

  void addReview(ServiceReview review) {
    reviews.insert(0, review);
    if (reviewsCount > 0) {
      double prevSum = rating * reviewsCount;
      reviewsCount += 1;
      rating = double.parse(((prevSum + review.rating) / reviewsCount).toStringAsFixed(2));
    } else {
      reviewsCount = 1;
      rating = review.rating;
    }
  }
}

class SOSModel {
  final String sosId;
  final String buyerId;
  final String buyerName;
  final String buyerAvatar;
  final String buyerCollege;
  final String university;
  final String title;
  final String description;
  final double reward;
  final String deadline;
  final String createdAt;
  String status; // 'OPEN', 'COMPLETED'
  int offersCount;

  SOSModel({
    required this.sosId,
    required this.buyerId,
    required this.buyerName,
    required this.buyerAvatar,
    required this.buyerCollege,
    required this.university,
    required this.title,
    required this.description,
    required this.reward,
    required this.deadline,
    required this.createdAt,
    this.status = 'OPEN',
    this.offersCount = 0,
  });
}

class OrderModel {
  final String orderId;
  final String serviceId;
  final String serviceTitle;
  final String category;
  final String buyerId;
  final String buyerName;
  final String providerId;
  final String providerName;
  final double totalAmount;
  final double commissionFee;
  final double netAmount;
  String escrowStatus; // 'Held', 'Released', 'Refunded', 'Frozen'
  String orderStatus; // 'MENUNGGU_BAYARAN', 'MENUNGGU_TERIMA', 'SEDANG_DILAKUKAN', 'MENUNGGU_PENGESAHAN', 'SELESAI', 'DIBATALKAN', 'PERTIKAIAN'
  String? proofFileUrl;
  final String createdAt;
  String deliveryNote;
  double? rating;
  String? reviewComment;
  List<String>? reviewTags;

  OrderModel({
    required this.orderId,
    required this.serviceId,
    required this.serviceTitle,
    required this.category,
    required this.buyerId,
    required this.buyerName,
    required this.providerId,
    required this.providerName,
    required this.totalAmount,
    required this.commissionFee,
    required this.netAmount,
    required this.escrowStatus,
    required this.orderStatus,
    this.proofFileUrl,
    required this.createdAt,
    required this.deliveryNote,
    this.rating,
    this.reviewComment,
    this.reviewTags,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final String timestamp;
  final bool isWarning;
  final String? warningText;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    this.isWarning = false,
    this.warningText,
  });
}

class DisputeModel {
  final String disputeId;
  final String orderId;
  final String serviceTitle;
  final String raisedByName;
  final String providerName;
  final double amount;
  final String reason;
  final String evidenceUrl;
  String status; // 'Open', 'Resolved'
  String? adminResolution;

  DisputeModel({
    required this.disputeId,
    required this.orderId,
    required this.serviceTitle,
    required this.raisedByName,
    required this.providerName,
    required this.amount,
    required this.reason,
    required this.evidenceUrl,
    this.status = 'Open',
    this.adminResolution,
  });
}

