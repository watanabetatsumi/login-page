"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { LogOut, User, Bell, Calendar, Settings } from "lucide-react"

type User = {
  email: string
  name: string
}

export default function WelcomePage() {
  const router = useRouter()
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // クライアントサイドでのみ実行
    const userData = localStorage.getItem("currentUser")

    if (userData) {
      setUser(JSON.parse(userData))
    } else {
      // ユーザーデータがない場合はログインページにリダイレクト
      router.push("/")
    }

    setLoading(false)
  }, [router])

  const handleLogout = () => {
    localStorage.removeItem("currentUser")
    router.push("/")
  }

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center">
        <div className="flex flex-col items-center">
          <svg
            className="animate-spin h-10 w-10 text-primary mb-4"
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
          <p className="text-muted-foreground">読み込み中...</p>
        </div>
      </div>
    )
  }

  if (!user) {
    return null // リダイレクト中
  }

  const currentDate = new Date()
  const formattedDate = new Intl.DateTimeFormat("ja-JP", {
    year: "numeric",
    month: "long",
    day: "numeric",
    weekday: "long",
  }).format(currentDate)

  return (
    <main className="min-h-screen bg-gradient-to-b from-slate-50 to-slate-100 p-4">
      <div className="max-w-4xl mx-auto">
        <div className="flex justify-between items-center mb-6">
          <h1 className="text-2xl font-bold">マイダッシュボード</h1>
          <div className="flex items-center space-x-2">
            <Button variant="ghost" size="icon">
              <Bell className="h-5 w-5" />
            </Button>
            <Button variant="ghost" size="icon">
              <Settings className="h-5 w-5" />
            </Button>
            <Avatar className="h-9 w-9">
              <AvatarImage src={`https://api.dicebear.com/7.x/initials/svg?seed=${user.name}`} alt={user.name} />
              <AvatarFallback>
                <User className="h-4 w-4" />
              </AvatarFallback>
            </Avatar>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="md:col-span-2">
            <Card>
              <CardHeader>
                <CardTitle>ようこそ、{user.name}さん！</CardTitle>
                <CardDescription>{formattedDate}</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex items-center space-x-4">
                  <Avatar className="h-16 w-16">
                    <AvatarImage src={`https://api.dicebear.com/7.x/initials/svg?seed=${user.name}`} alt={user.name} />
                    <AvatarFallback>
                      <User className="h-8 w-8" />
                    </AvatarFallback>
                  </Avatar>
                  <div>
                    <h2 className="text-xl font-semibold">{user.name}</h2>
                    <p className="text-muted-foreground">{user.email}</p>
                  </div>
                </div>

                <div className="bg-muted p-4 rounded-lg">
                  <div className="flex items-center mb-2">
                    <Calendar className="h-5 w-5 mr-2 text-primary" />
                    <h3 className="font-medium">今日のスケジュール</h3>
                  </div>
                  <ul className="space-y-2">
                    <li className="text-sm p-2 bg-background rounded border">
                      <span className="text-primary font-medium">10:00</span> - チームミーティング
                    </li>
                    <li className="text-sm p-2 bg-background rounded border">
                      <span className="text-primary font-medium">13:30</span> - プロジェクト進捗確認
                    </li>
                    <li className="text-sm p-2 bg-background rounded border">
                      <span className="text-primary font-medium">15:00</span> - クライアントとの打ち合わせ
                    </li>
                  </ul>
                </div>
              </CardContent>
            </Card>
          </div>

          <div>
            <Card>
              <CardHeader>
                <CardTitle>おすすめコンテンツ</CardTitle>
                <CardDescription>{user.name}さん向けの情報</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="bg-primary/10 p-3 rounded-lg">
                  <h3 className="font-medium text-primary mb-1">新機能のお知らせ</h3>
                  <p className="text-sm">ダッシュボードに新しい分析ツールが追加されました。</p>
                </div>
                <div className="bg-primary/10 p-3 rounded-lg">
                  <h3 className="font-medium text-primary mb-1">セミナーのご案内</h3>
                  <p className="text-sm">来週開催される「効率化ワークフロー」セミナーに参加しませんか？</p>
                </div>
                <div className="bg-primary/10 p-3 rounded-lg">
                  <h3 className="font-medium text-primary mb-1">お知らせ</h3>
                  <p className="text-sm">プロフィール情報を更新すると、よりパーソナライズされた情報が表示されます。</p>
                </div>
              </CardContent>
              <CardFooter>
                <Button variant="outline" className="w-full" onClick={handleLogout}>
                  <LogOut className="mr-2 h-4 w-4" />
                  ログアウト
                </Button>
              </CardFooter>
            </Card>
          </div>
        </div>
      </div>
    </main>
  )
}

