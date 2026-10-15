import http from 'node:http';
import { URL } from 'node:url';
import { config } from './config/config.js';
import { handleUserRoutes } from './routes/userRoutes.js';

const server = http.createServer(async (req, res) => {
  // CORS 및 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  const parsedUrl = new URL(req.url, `http://${req.headers.host}`);
  const pathname = parsedUrl.pathname;
  const method = req.method;

  // 요청 본문(Body) 버퍼 파싱
  let body = null;
  if (['POST', 'PUT', 'PATCH'].includes(method)) {
    try {
      const buffers = [];
      for await (const chunk of req) {
        buffers.push(chunk);
      }
      const rawBody = Buffer.concat(buffers).toString();
      if (rawBody) {
        body = JSON.parse(rawBody);
      }
    } catch {
      res.writeHead(400, { 'Content-Type': 'application/json; charset=utf-8' });
      res.end(JSON.stringify({ error: '올바르지 않은 JSON 요청 형식입니다.' }));
      return;
    }
  }

  // 1. 루트 경로 안내
  if (pathname === '/' && method === 'GET') {
    res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify({
      name: config.appName,
      description: '서비스 제공자를 위한 개인정보 관리 시스템 (학습 및 연구용 뼈대)',
      notice: '본 프로젝트는 교육용이며, 악의적 사용 시 법적 책임을 지지 않습니다.',
      endpoints: [
        'POST   /api/users      - 사용자 등록 (비밀번호 해시, 민감정보 암호화 실습)',
        'GET    /api/users      - 사용자 목록 조회 (마스킹 적용)',
        'GET    /api/users/:id  - 사용자 상세 조회 (마스킹 적용)',
        'DELETE /api/users/:id  - 개인정보 파기 (완전 삭제 및 익명화)'
      ]
    }, null, 2));
    return;
  }

  // 2. 헬스 체크
  if (pathname === '/health' && method === 'GET') {
    res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify({ status: 'ok', timestamp: new Date().toISOString() }));
    return;
  }

  // 3. 사용자 관련 라우팅
  const handled = await handleUserRoutes(req, res, pathname, method, body);
  if (handled) return;

  // 4. 404 Not Found
  res.writeHead(404, { 'Content-Type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify({ error: '요청한 엔드포인트를 찾을 수 없습니다.' }));
});

server.listen(config.port, () => {
  console.log(`====================================================`);
  console.log(`🛡️  ${config.appName} 서버가 시작되었습니다.`);
  console.log(`🌐 포트: http://localhost:${config.port}`);
  console.log(`⚠️  본 프로젝트는 교육/학습용 오픈소스 뼈대입니다.`);
  console.log(`====================================================`);
});
