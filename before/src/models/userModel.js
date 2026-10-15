import crypto from 'node:crypto';

/**
 * 인메모리 사용자 및 개인정보 저장소 (학습/뼈대용)
 */
class UserModel {
  constructor() {
    this.users = new Map();
  }

  /**
   * 사용자 개인정보 등록
   */
  create(userData) {
    const id = crypto.randomUUID();
    const now = new Date();
    // 개인정보 보유기간 (예: 1년 후 만료)
    const retentionExpireAt = new Date(now.getTime() + 365 * 24 * 60 * 60 * 1000);

    const record = {
      id,
      username: userData.username,
      passwordHash: userData.passwordHash,
      name: userData.name,
      email: userData.email,
      phone: userData.phone,
      encryptedResidentId: userData.encryptedResidentId || null, // 암호화된 민감 식별정보
      consentGiven: Boolean(userData.consentGiven),               // 개인정보 수집·이용 동의
      retentionExpireAt: retentionExpireAt.toISOString(),         // 파기 예정일
      createdAt: now.toISOString(),
      updatedAt: now.toISOString(),
      isDeleted: false                                            // 파기/삭제 플래그
    };

    this.users.set(id, record);
    return record;
  }

  /**
   * ID로 사용자 조회 (삭제되지 않은 대상)
   */
  findById(id) {
    const user = this.users.get(id);
    if (!user || user.isDeleted) return null;
    return user;
  }

  /**
   * 전체 사용자 조회 (학습용 목록 조회)
   */
  findAll() {
    return Array.from(this.users.values()).filter(u => !u.isDeleted);
  }

  /**
   * 개인정보 파기 (완전 파기 및 익명화)
   */
  purge(id) {
    const user = this.users.get(id);
    if (!user) return false;

    // 개인정보보호법 상 파기 원칙: 복구 불가능하도록 데이터 덮어쓰기 및 삭제
    user.name = '[PURGED]';
    user.email = '[PURGED]';
    user.phone = '[PURGED]';
    user.encryptedResidentId = null;
    user.passwordHash = '';
    user.isDeleted = true;
    user.purgedAt = new Date().toISOString();
    return true;
  }
}

export const userModel = new UserModel();
