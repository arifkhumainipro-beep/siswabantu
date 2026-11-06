import React, { useState } from 'react';

export default function IPTALogoBadge({ ipta, size = 24, className = '' }) {
  const [imageError, setImageError] = useState(false);

  if (!ipta) {
    return (
      <div 
        style={{ width: size, height: size }} 
        className={`rounded-full bg-indigo-100 border border-indigo-200 flex items-center justify-center text-[10px] font-extrabold text-indigo-700 ${className}`}
      >
        🎓
      </div>
    );
  }

  return (
    <div
      style={{
        width: size,
        height: size,
        minWidth: size,
        minHeight: size,
        backgroundColor: ipta.primaryColor,
        borderColor: ipta.secondaryColor,
      }}
      className={`relative rounded-full border flex items-center justify-center overflow-hidden shadow-sm shrink-0 select-none ${className}`}
      title={`${ipta.fullName} (${ipta.code}) - ${ipta.state}`}
    >
      {!imageError && ipta.logoUrl ? (
        <img
          src={ipta.logoUrl}
          alt={ipta.code}
          className="w-full h-full object-cover"
          onError={() => setImageError(true)}
          loading="lazy"
        />
      ) : (
        <span
          style={{
            color: '#FFFFFF',
            fontSize: Math.max(8, Math.floor(size * 0.38)),
            fontWeight: 900,
            letterSpacing: '-0.05em',
          }}
        >
          {ipta.code.length > 4 ? ipta.code.substring(0, 3) : ipta.code}
        </span>
      )}
    </div>
  );
}

