import { UserController } from '../controllers/userController.js';

/**
 * 간단한 HTTP 요청 라우터
 */
export async function handleUserRoutes(req, res, pathname, method, body) {
  // 1. POST /api/users - 사용자 등록
  if (pathname === '/api/users' && method === 'POST') {
    const result = UserController.register(body || {});
    return sendJson(res, result.status, result.data);
  }

  // 2. GET /api/users - 사용자 목록 조회
  if (pathname === '/api/users' && method === 'GET') {
    const result = UserController.listUsers();
    return sendJson(res, result.status, result.data);
  }

  // 3. GET /api/users/:id - 사용자 단건 조회
  const matchGet = pathname.match(/^\/api\/users\/([a-zA-Z0-9-]+)$/);
  if (matchGet && method === 'GET') {
    const id = matchGet[1];
    const result = UserController.getProfile(id);
    return sendJson(res, result.status, result.data);
  }

  // 4. DELETE /api/users/:id - 사용자 개인정보 파기
  const matchDelete = pathname.match(/^\/api\/users\/([a-zA-Z0-9-]+)$/);
  if (matchDelete && method === 'DELETE') {
    const id = matchDelete[1];
    const result = UserController.purgeUser(id);
    return sendJson(res, result.status, result.data);
  }

  return false;
}

function sendJson(res, statusCode, data) {
  res.writeHead(statusCode, { 'Content-Type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify(data, null, 2));
  return true;
}
