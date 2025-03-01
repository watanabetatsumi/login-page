import { NextResponse } from "next/server"

// サンプルユーザーデータ（実際のアプリケーションではデータベースを使用します）
const USERS = [
  { email: "tanaka@example.com", password: "password123", name: "田中太郎" },
  { email: "yamada@example.com", password: "password123", name: "山田花子" },
  { email: "suzuki@example.com", password: "password123", name: "鈴木一郎" },
]

export async function POST(request: Request) {
  try {
    const { email, password } = await request.json()

    // 認証処理
    const user = USERS.find((user) => user.email === email && user.password === password)

    if (!user) {
      return NextResponse.json({ error: "メールアドレスまたはパスワードが正しくありません" }, { status: 401 })
    }

    // パスワードを除外したユーザー情報を返す
    const { password: _, ...userWithoutPassword } = user

    return NextResponse.json({ user: userWithoutPassword })
  } catch (error) {
    console.error("認証エラー:", error)
    return NextResponse.json({ error: "認証処理中にエラーが発生しました" }, { status: 500 })
  }
}

