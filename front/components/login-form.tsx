"use client"

import type React from "react"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { AtSign, Lock, LogIn } from "lucide-react"

// サンプルユーザーデータ
const USERS = [
  { email: "tanaka@example.com", password: "password123", name: "田中太郎" },
  { email: "yamada@example.com", password: "password123", name: "山田花子" },
  { email: "suzuki@example.com", password: "password123", name: "鈴木一郎" },
]

export default function LoginForm() {
  const router = useRouter()
  // 定数を宣言しつつ、更新する関数もセットで作ってる。useStateはWebページ上で動的な値を持つためのもの
  // 静的なページは基本的に定数になる
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [error, setError] = useState("")
  const [isLoading, setIsLoading] = useState(false)

  // 関数をhandleSubmitという定数として定義
  // 非同期処理とすることで、ページを表示しつつ、処理を行うことができる（ログインボタンでぐるぐる）
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError("")
    setIsLoading(true)

    try {
      // 実際のアプリケーションでは、ここでAPIリクエストを行います
      // 例: const response = await fetch('/api/login', { method: 'POST', body: JSON.stringify({ email, password }) });

      // 簡易的な認証処理（デモ用）
      await new Promise((resolve) => setTimeout(resolve, 500)) // ローディング表示のための遅延

      const user = USERS.find((user) => user.email === email && user.password === password)

      if (user) {
        // ユーザー情報をローカルストレージに保存
        localStorage.setItem("currentUser", JSON.stringify(user))
        // ウェルカムページにリダイレクト
        router.push("/welcome")
      } else {
        setError("メールアドレスまたはパスワードが正しくありません")
      }
    } catch (err) {
      setError("ログイン中にエラーが発生しました。もう一度お試しください。")
      console.error(err)
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <Card className="w-full">
      <CardHeader>
        <CardTitle>ログイン</CardTitle>
        <CardDescription>アカウント情報を入力してログインしてください</CardDescription>
      </CardHeader>
      <form onSubmit={handleSubmit}>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="email">メールアドレス</Label>
            <div className="relative">
              <AtSign className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
              <Input
                id="email"
                type="email"
                placeholder="your@email.com"
                className="pl-10"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                disabled={isLoading}
              />
            </div>
          </div>
          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <Label htmlFor="password">パスワード</Label>
              <a href="#" className="text-sm text-primary hover:underline">
                パスワードをお忘れですか？
              </a>
            </div>
            <div className="relative">
              <Lock className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
              <Input
                id="password"
                type="password"
                className="pl-10"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                disabled={isLoading}
              />
            </div>
          </div>
          {error && <p className="text-sm text-destructive">{error}</p>}
        </CardContent>
        <CardFooter>
          <Button type="submit" className="w-full" disabled={isLoading}>
            {isLoading ? (
              <>
                <svg
                  className="animate-spin -ml-1 mr-3 h-4 w-4 text-white"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                  <path
                    className="opacity-75"
                    fill="currentColor"
                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                  ></path>
                </svg>
                ログイン中...
              </>
            ) : (
              <>
                <LogIn className="mr-2 h-4 w-4" />
                ログイン
              </>
            )}
          </Button>
        </CardFooter>
      </form>
    </Card>
  )
}

