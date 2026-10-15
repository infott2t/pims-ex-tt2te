import { userModel } from '../models/userModel.js';
import { PrivacyService } from '../services/privacyService.js';

export class UserController {
  /**
   * 사용자 개인정보 등록 (회원가입/정보수집)
   */
  static register(reqData) {
    const { username, password, name, email, phone, residentId, consentGiven } = reqData;

    if (!username || !password || !name || !email) {
      return { status: 400, data: { error: '필수 입력 항목(username, password, name, email)이 누락되었습니다.' } };
    }

    if (!consentGiven) {
      return { status: 400, data: { error: '개인정보 수집 및 이용에 대한 동의(consentGiven: true)가 필요합니다.' } };
    }

    // 1. 비밀번호 단방향 해시화
    const passwordHash = PrivacyService.hashPassword(password);

    // 2. 민감정보(주민등록번호 등) 양방향 암호화
    const encryptedResidentId = residentId ? PrivacyService.encryptSensitiveData(residentId) : null;

    // 3. 데이터 저장
    const created = userModel.create({
      username,
      passwordHash,
      name,
      email,
      phone,
      encryptedResidentId,
      consentGiven
    });

    return {
      status: 201,
      data: {
        message: '사용자 개인정보가 안전하게 등록되었습니다.',
        user: {
          id: created.id,
          username: created.username,
          maskedName: PrivacyService.maskName(created.name),
          maskedEmail: PrivacyService.maskEmail(created.email),
          retentionExpireAt: created.retentionExpireAt,
          createdAt: created.createdAt
        }
      }
    };
  }

  /**
   * 사용자 개인정보 조회 (마스킹 적용 반환)
   */
  static getProfile(id) {
    const user = userModel.findById(id);
    if (!user) {
      return { status: 404, data: { error: '사용자를 찾을 수 없습니다.' } };
    }

    // 개인정보 보호 원칙: 불필요한 민감정보 노출 방지 및 마스킹 처리
    return {
      status: 200,
      data: {
        id: user.id,
        username: user.username,
        name: PrivacyService.maskName(user.name),
        email: PrivacyService.maskEmail(user.email),
        phone: PrivacyService.maskPhone(user.phone),
        hasEncryptedResidentId: Boolean(user.encryptedResidentId),
        consentGiven: user.consentGiven,
        retentionExpireAt: user.retentionExpireAt,
        createdAt: user.createdAt
      }
    };
  }

  /**
   * 목록 조회 (학습용)
   */
  static listUsers() {
    const users = userModel.findAll().map(u => ({
      id: u.id,
      username: u.username,
      name: PrivacyService.maskName(u.name),
      email: PrivacyService.maskEmail(u.email),
      phone: PrivacyService.maskPhone(u.phone),
      createdAt: u.createdAt
    }));

    return { status: 200, data: { total: users.length, users } };
  }

  /**
   * 사용자 개인정보 파기 (회원 탈퇴 / 권리 행사)
   */
  static purgeUser(id) {
    const success = userModel.purge(id);
    if (!success) {
      return { status: 404, data: { error: '파기할 사용자를 찾을 수 없습니다.' } };
    }

    return {
      status: 200,
      data: { message: '개인정보가 복구 불가능하도록 파기 처리되었습니다.' }
    };
  }
}
