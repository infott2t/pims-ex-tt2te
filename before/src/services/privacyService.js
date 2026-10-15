import crypto from 'node:crypto';
import { config } from '../config/config.js';

/**
 * PrivacyService
 * 개인정보 보호 및 처리를 위한 핵심 유틸리티 (학습용)
 */
export class PrivacyService {
  /**
   * 단방향 암호화 (해시) - 비밀번호 등
   */
  static hashPassword(password) {
    const salt = crypto.randomBytes(16).toString('hex');
    const hash = crypto.scryptSync(password, salt, 64).toString('hex');
    return `${salt}:${hash}`;
  }

  /**
   * 비밀번호 검증
   */
  static verifyPassword(password, storedHash) {
    const [salt, key] = storedHash.split(':');
    const keyBuffer = Buffer.from(key, 'hex');
    const derivedKey = crypto.scryptSync(password, salt, 64);
    return crypto.timingSafeEqual(keyBuffer, derivedKey);
  }

  /**
   * 양방향 암호화 (AES-256-CBC) - 민감정보(주민등록번호, 계좌번호 등)
   */
  static encryptSensitiveData(plainText) {
    const iv = crypto.randomBytes(16);
    const key = crypto.createHash('sha256').update(String(config.encryptionKey)).digest();
    const cipher = crypto.createCipheriv('aes-256-cbc', key, iv);
    let encrypted = cipher.update(plainText, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    return `${iv.toString('hex')}:${encrypted}`;
  }

  /**
   * 양방향 복호화 (AES-256-CBC)
   */
  static decryptSensitiveData(encryptedData) {
    const [ivHex, cipherText] = encryptedData.split(':');
    const iv = Buffer.from(ivHex, 'hex');
    const key = crypto.createHash('sha256').update(String(config.encryptionKey)).digest();
    const decipher = crypto.createDecipheriv('aes-256-cbc', key, iv);
    let decrypted = decipher.update(cipherText, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    return decrypted;
  }

  /**
   * 개인정보 마스킹 (이메일)
   * 예: testuser@example.com -> te*****r@example.com
   */
  static maskEmail(email) {
    if (!email || !email.includes('@')) return email;
    const [localPart, domain] = email.split('@');
    if (localPart.length <= 2) {
      return `${localPart[0]}*@${domain}`;
    }
    const maskedLocal = localPart.slice(0, 2) + '*'.repeat(Math.max(1, localPart.length - 3)) + localPart.slice(-1);
    return `${maskedLocal}@${domain}`;
  }

  /**
   * 개인정보 마스킹 (전화번호)
   * 예: 010-1234-5678 -> 010-****-5678
   */
  static maskPhone(phone) {
    if (!phone) return phone;
    return phone.replace(/(\d{2,3})-(\d{3,4})-(\d{4})/, '$1-****-$3');
  }

  /**
   * 개인정보 마스킹 (이름)
   * 예: 홍길동 -> 홍*동, 이순신 -> 이*신, John -> J**n
   */
  static maskName(name) {
    if (!name || name.length <= 1) return name;
    if (name.length === 2) return `${name[0]}*`;
    return name[0] + '*'.repeat(name.length - 2) + name.slice(-1);
  }
}
