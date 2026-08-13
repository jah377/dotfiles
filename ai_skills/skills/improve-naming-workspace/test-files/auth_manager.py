"""Authentication and session management for the web application."""
import hashlib
import time
from dataclasses import dataclass, field
from typing import Optional


@dataclass
class UserRecord:
    user_id: str
    email: str
    password_hash: str
    created_at: float = field(default_factory=time.time)
    is_active: bool = True


@dataclass
class Session:
    token: str
    user_id: str
    expires_at: float
    ip_address: str


class AuthManager:
    """Manages user authentication, sessions, and password operations."""

    def __init__(self, secret_key: str, session_ttl: int = 3600):
        self.secret_key = secret_key
        self.session_ttl = session_ttl
        self.sessions: dict[str, Session] = {}
        self.users: dict[str, UserRecord] = {}

    @property
    def active_session_count(self) -> int:
        """Return the number of currently non-expired sessions."""
        now = time.time()
        return sum(1 for s in self.sessions.values() if s.expires_at > now)

    def register_user(
        self,
        email: str,
        password: str,
        user_id: Optional[str] = None,
    ) -> UserRecord:
        """Create a new user record with a hashed password."""
        uid = user_id or hashlib.sha256(email.encode()).hexdigest()[:12]
        hashed = self._hash_password(password)
        record = UserRecord(user_id=uid, email=email, password_hash=hashed)
        self.users[uid] = record
        return record

    def authenticate(self, email: str, password: str) -> Optional[Session]:
        """Verify credentials and return a new session, or None if invalid."""
        user = next((u for u in self.users.values() if u.email == email), None)
        if user is None or not user.is_active:
            return None
        if not self._verify_password(password, user.password_hash):
            return None
        return self._create_session(user.user_id)

    def invalidate(self, token: str) -> bool:
        """Remove a session by token. Returns True if it existed."""
        return self.sessions.pop(token, None) is not None

    def _hash_password(self, pw: str) -> str:
        salted = pw + self.secret_key
        return hashlib.sha256(salted.encode()).hexdigest()

    def _verify_password(self, pw: str, stored: str) -> bool:
        return self._hash_password(pw) == stored

    def _create_session(self, uid: str, ip: str = "0.0.0.0") -> Session:
        token = hashlib.sha256(f"{uid}{time.time()}".encode()).hexdigest()
        session = Session(
            token=token,
            user_id=uid,
            expires_at=time.time() + self.session_ttl,
            ip_address=ip,
        )
        self.sessions[token] = session
        return session


def hash_token(raw: str, length: int = 16) -> str:
    """Return a truncated SHA-256 hex digest of the input string."""
    return hashlib.sha256(raw.encode()).hexdigest()[:length]
