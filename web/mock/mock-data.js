// モックデータ
const mockUsers = [
    {
        userId: 'user2',
        displayName: 'ハナコ',
        grade: '2年生',
        course: 'Webデザインコース',
        interests: ['デザイン', 'イラスト', '音楽'],
        bio: 'Webデザイン勉強してます！デザイン好きな人と繋がりたいです。',
        photoUrl: 'https://via.placeholder.com/150/FF69B4/FFFFFF?text=H',
        compatibilityScore: 85
    },
    {
        userId: 'user3',
        displayName: 'ジロウ',
        grade: '1年生',
        course: 'プログラミングコース',
        interests: ['プログラミング', 'ゲーム', 'アニメ'],
        bio: 'ゲーム開発に興味があります！一緒に勉強しましょう。',
        photoUrl: 'https://via.placeholder.com/150/4169E1/FFFFFF?text=J',
        compatibilityScore: 92
    },
    {
        userId: 'user4',
        displayName: 'サクラ',
        grade: '2年生',
        course: '動画編集コース',
        interests: ['動画編集', '映画', '音楽'],
        bio: 'YouTubeで動画投稿してます。映画好きな人話しましょう！',
        photoUrl: 'https://via.placeholder.com/150/FF1493/FFFFFF?text=S',
        compatibilityScore: 68
    },
    {
        userId: 'user5',
        displayName: 'ケンタ',
        grade: '3年生',
        course: 'プログラミングコース',
        interests: ['プログラミング', 'AI', 'ロボット'],
        bio: 'AI・機械学習に興味があります。技術の話ができる友達募集中！',
        photoUrl: 'https://via.placeholder.com/150/32CD32/FFFFFF?text=K',
        compatibilityScore: 78
    }
];

const mockReceivedLikes = [
    {
        likeId: 'like1',
        fromUser: mockUsers[0], // ハナコ
        createdAt: new Date(Date.now() - 3600000)
    },
    {
        likeId: 'like2',
        fromUser: mockUsers[1], // ジロウ
        createdAt: new Date(Date.now() - 7200000)
    }
];

const mockMatches = [
    {
        matchId: 'match1',
        user: mockUsers[0], // ハナコ
        lastMessage: 'よろしくお願いします！',
        lastMessageAt: new Date(Date.now() - 1800000),
        unreadCount: 1
    },
    {
        matchId: 'match2',
        user: mockUsers[1], // ジロウ
        lastMessage: null,
        lastMessageAt: new Date(Date.now() - 3600000),
        unreadCount: 0
    }
];

const mockMessages = {
    'match1': [
        {
            messageId: 'msg1',
            senderId: 'user2',
            content: 'こんにちは！マッチングありがとうございます。',
            createdAt: new Date(Date.now() - 3600000),
            isOwn: false
        },
        {
            messageId: 'msg2',
            senderId: 'user1',
            content: 'こちらこそ！よろしくお願いします。',
            createdAt: new Date(Date.now() - 3000000),
            isOwn: true
        },
        {
            messageId: 'msg3',
            senderId: 'user2',
            content: 'デザインの話とかできたら嬉しいです！',
            createdAt: new Date(Date.now() - 1800000),
            isOwn: false
        }
    ],
    'match2': []
};

const currentUser = {
    userId: 'user1',
    displayName: 'タロウ',
    grade: '1年生',
    course: 'プログラミングコース',
    interests: ['プログラミング', 'ゲーム', 'アニメ'],
    bio: 'プログラミング勉強中です！同じ趣味の友達が欲しいです。',
    photoUrl: 'https://via.placeholder.com/150/4285F4/FFFFFF?text=T'
};
