import { auth } from "@/lib/auth";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";

export default async function DashboardPage() {
  const session = await auth();

  return (
    <div>
      <h1 className="mb-6 text-3xl font-bold">Dashboard</h1>
      <Card>
        <CardHeader>
          <CardTitle>Hello World</CardTitle>
          <CardDescription>
            Welcome back, {session?.user?.name || session?.user?.email}!
          </CardDescription>
        </CardHeader>
        <CardContent>
          <p className="text-muted-foreground">
            You are now logged into the admin dashboard.
          </p>
        </CardContent>
      </Card>
    </div>
  );
}
