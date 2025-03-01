import LoginForm from "@/components/login-form"

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-4 bg-gradient-to-b from-slate-50 to-slate-100">
      <div className="w-full max-w-md mx-auto">
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold">ようこそ</h1>
          <p className="text-muted-foreground mt-2">アカウントにログインしてください</p>
        </div>
        <LoginForm />
      </div>
    </main>
  )
}

