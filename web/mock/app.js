// アプリケーション状態
let currentTab = 'discover';
let currentChatMatchId = null;
let displayedUsers = [...mockUsers];

// 初期化
document.addEventListener('DOMContentLoaded', () => {
    // ログイン状態チェック
    const isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
    if (isLoggedIn) {
        showMainScreen();
    }
});

// ログイン
function login() {
    localStorage.setItem('isLoggedIn', 'true');
    showMainScreen();
}

// ログアウト
function logout() {
    localStorage.removeItem('isLoggedIn');
    document.getElementById('login-screen').classList.remove('hidden');
    document.getElementById('main-screen').classList.add('hidden');
}

// メイン画面表示
function showMainScreen() {
    document.getElementById('login-screen').classList.add('hidden');
    document.getElementById('main-screen').classList.remove('hidden');
    renderUserCards();
    renderReceivedLikes();
    renderMatches();
}

// タブ切り替え
function showTab(tabName) {
    // ナビゲーションの更新
    document.querySelectorAll('.nav-item').forEach(item => {
        item.classList.remove('active');
    });
    document.querySelector(`[data-tab="${tabName}"]`).classList.add('active');

    // タブコンテンツの更新
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.classList.add('hidden');
    });
    document.getElementById(`${tabName}-tab`).classList.remove('hidden');

    currentTab = tabName;
}

// ユーザーカード表示
function renderUserCards() {
    const container = document.getElementById('user-cards');
    container.innerHTML = '';

    if (displayedUsers.length === 0) {
        container.innerHTML = '<p style="text-align: center; color: #999; padding: 40px;">表示できるユーザーがいません</p>';
        return;
    }

    displayedUsers.forEach(user => {
        const card = document.createElement('div');
        card.className = 'user-card';
        card.innerHTML = `
            <div class="user-card-header">
                <img src="${user.photoUrl}" alt="${user.displayName}" class="user-photo">
                <div class="user-info">
                    <h3>${user.displayName}</h3>
                    <p class="grade">${user.grade} - ${user.course}</p>
                    <span class="compatibility">相性 ${user.compatibilityScore}%</span>
                </div>
            </div>
            <div class="interests">
                ${user.interests.map(interest => `<span class="tag">${interest}</span>`).join('')}
            </div>
            <p class="bio">${user.bio}</p>
            <div class="card-actions">
                <button class="btn-skip" onclick="skipUser('${user.userId}')">スキップ</button>
                <button class="btn-like" onclick="sendLike('${user.userId}')">❤️ いいね</button>
            </div>
        `;
        container.appendChild(card);
    });
}

// いいね送信
function sendLike(userId) {
    const user = displayedUsers.find(u => u.userId === userId);
    
    // ランダムでマッチング判定
    const isMatch = Math.random() > 0.5;
    
    if (isMatch) {
        alert(`🎉 ${user.displayName}さんとマッチングしました！`);
        
        // マッチリストに追加
        mockMatches.unshift({
            matchId: `match_${Date.now()}`,
            user: user,
            lastMessage: null,
            lastMessageAt: new Date(),
            unreadCount: 0
        });
        mockMessages[`match_${Date.now()}`] = [];
        
        renderMatches();
    } else {
        alert(`${user.displayName}さんにいいねを送りました！`);
    }
    
    // カードを削除
    displayedUsers = displayedUsers.filter(u => u.userId !== userId);
    renderUserCards();
}

// スキップ
function skipUser(userId) {
    displayedUsers = displayedUsers.filter(u => u.userId !== userId);
    renderUserCards();
}

// 受信いいね表示
function renderReceivedLikes() {
    const container = document.getElementById('likes-list');
    container.innerHTML = '';

    if (mockReceivedLikes.length === 0) {
        container.innerHTML = '<p style="text-align: center; color: #999; padding: 40px;">いいねはありません</p>';
        document.getElementById('likes-badge').style.display = 'none';
        return;
    }

    document.getElementById('likes-badge').textContent = mockReceivedLikes.length;

    mockReceivedLikes.forEach(like => {
        const item = document.createElement('div');
        item.className = 'like-item';
        item.innerHTML = `
            <img src="${like.fromUser.photoUrl}" alt="${like.fromUser.displayName}">
            <div class="like-info">
                <h4>${like.fromUser.displayName}</h4>
                <p class="grade">${like.fromUser.grade} - ${like.fromUser.course}</p>
            </div>
            <div class="like-actions">
                <button class="btn-reject" onclick="rejectLike('${like.likeId}')">✕</button>
                <button class="btn-accept" onclick="acceptLike('${like.likeId}')">❤️</button>
            </div>
        `;
        container.appendChild(item);
    });
}

// いいね承認
function acceptLike(likeId) {
    const like = mockReceivedLikes.find(l => l.likeId === likeId);
    alert(`🎉 ${like.fromUser.displayName}さんとマッチングしました！`);
    
    // マッチリストに追加
    mockMatches.unshift({
        matchId: `match_${Date.now()}`,
        user: like.fromUser,
        lastMessage: null,
        lastMessageAt: new Date(),
        unreadCount: 0
    });
    
    // いいねリストから削除
    const index = mockReceivedLikes.findIndex(l => l.likeId === likeId);
    mockReceivedLikes.splice(index, 1);
    
    renderReceivedLikes();
    renderMatches();
}

// いいね拒否
function rejectLike(likeId) {
    const index = mockReceivedLikes.findIndex(l => l.likeId === likeId);
    mockReceivedLikes.splice(index, 1);
    renderReceivedLikes();
}

// マッチ一覧表示
function renderMatches() {
    const container = document.getElementById('matches-list');
    container.innerHTML = '';

    if (mockMatches.length === 0) {
        container.innerHTML = '<p style="text-align: center; color: #999; padding: 40px;">マッチングはありません</p>';
        return;
    }

    mockMatches.forEach(match => {
        const item = document.createElement('div');
        item.className = 'match-item';
        item.innerHTML = `
            <img src="${match.user.photoUrl}" alt="${match.user.displayName}">
            <div class="match-info">
                <h4>${match.user.displayName}</h4>
                <p class="grade">${match.lastMessage || 'メッセージを送ってみよう'}</p>
            </div>
            <button class="btn-chat" onclick="openChat('${match.matchId}', '${match.user.displayName}')">チャット</button>
        `;
        container.appendChild(item);
    });
}

// チャット開く
function openChat(matchId, userName) {
    currentChatMatchId = matchId;
    document.getElementById('chat-user-name').textContent = userName;
    document.getElementById('main-screen').classList.add('hidden');
    document.getElementById('chat-screen').classList.remove('hidden');
    
    renderMessages();
}

// チャット閉じる
function closeChat() {
    document.getElementById('chat-screen').classList.add('hidden');
    document.getElementById('main-screen').classList.remove('hidden');
    currentChatMatchId = null;
}

// メッセージ表示
function renderMessages() {
    const container = document.getElementById('chat-messages');
    container.innerHTML = '';

    const messages = mockMessages[currentChatMatchId] || [];

    if (messages.length === 0) {
        container.innerHTML = '<p style="text-align: center; color: #999; padding: 40px;">メッセージを送ってみよう</p>';
        return;
    }

    messages.forEach(msg => {
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${msg.isOwn ? 'sent' : 'received'}`;
        messageDiv.innerHTML = `
            <div>${msg.content}</div>
            <div class="message-time">${formatTime(msg.createdAt)}</div>
        `;
        container.appendChild(messageDiv);
    });

    // スクロールを最下部に
    container.scrollTop = container.scrollHeight;
}

// メッセージ送信
function sendMessage() {
    const input = document.getElementById('message-input');
    const content = input.value.trim();

    if (!content) return;

    const newMessage = {
        messageId: `msg_${Date.now()}`,
        senderId: currentUser.userId,
        content: content,
        createdAt: new Date(),
        isOwn: true
    };

    if (!mockMessages[currentChatMatchId]) {
        mockMessages[currentChatMatchId] = [];
    }
    mockMessages[currentChatMatchId].push(newMessage);

    // マッチの最終メッセージを更新
    const match = mockMatches.find(m => m.matchId === currentChatMatchId);
    if (match) {
        match.lastMessage = content;
        match.lastMessageAt = new Date();
    }

    input.value = '';
    renderMessages();
    renderMatches();
}

// Enterキーでメッセージ送信
document.addEventListener('DOMContentLoaded', () => {
    const input = document.getElementById('message-input');
    if (input) {
        input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });
    }
});

// 時刻フォーマット
function formatTime(date) {
    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');
    return `${hours}:${minutes}`;
}
