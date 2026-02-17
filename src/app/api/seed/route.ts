import { NextResponse } from "next/server";
import bcrypt from "bcryptjs";
import clientPromise from "@/lib/mongodb";

export async function GET() {
  try {
    const client = await clientPromise;
    const db = client.db();

    const existingUser = await db
      .collection("users")
      .findOne({ email: "admin@example.com" });

    if (existingUser) {
      return NextResponse.json({ message: "Admin user already exists" });
    }

    const hashedPassword = await bcrypt.hash("admin123", 12);

    await db.collection("users").insertOne({
      name: "Admin",
      email: "admin@example.com",
      password: hashedPassword,
      createdAt: new Date(),
    });

    return NextResponse.json({ message: "Admin user created successfully" });
  } catch (error) {
    return NextResponse.json(
      { message: "Error seeding database", error: String(error) },
      { status: 500 }
    );
  }
}
