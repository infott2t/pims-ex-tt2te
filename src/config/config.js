/**
 * PIMS Configuration (학습용 기본 설정)
 */
export const config = {
  port: process.env.PORT || 3000,
  env: process.env.NODE_ENV || 'development',
  encryptionKey: process.env.ENCRYPTION_KEY || 'pims-secret-key-32-bytes-length!', // 32바이트 키
  appName: 'PIMS Educational Scaffold'
};
