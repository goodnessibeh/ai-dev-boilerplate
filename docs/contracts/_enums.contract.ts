// ============================================================
// [Project Name] — Master Enum Definitions
// Single source of truth for ALL enum values across the system
//
// CONVENTION:
//   Enum names:  PascalCase       (e.g., ResourceCategory)
//   Enum values: UPPER_SNAKE_CASE (e.g., "ACTIVE")
//
// USAGE:
//   Backend:  Django TextChoices mirrors these exactly
//   Frontend: Import from this file or copy values
//   Mobile:   Import from this file or copy values
//   API:      JSON responses use these exact string values
//   Database: Stored as these exact strings
//
// RULE: Never define enum values anywhere else. Update here first.
// ============================================================

// --- User & Auth ---

export enum UserRole {
  USER = "USER",
  ADMIN = "ADMIN",
  SUPER_ADMIN = "SUPER_ADMIN",
}

// --- Common Status ---

export enum Status {
  ACTIVE = "ACTIVE",
  INACTIVE = "INACTIVE",
  DRAFT = "DRAFT",
  ARCHIVED = "ARCHIVED",
}

// --- Notifications ---

export enum NotificationType {
  SYSTEM = "SYSTEM",
  // Add project-specific notification types
}

// --- Payments (if applicable) ---

export enum PaymentStatus {
  PENDING = "PENDING",
  SUCCESS = "SUCCESS",
  FAILED = "FAILED",
  REFUNDED = "REFUNDED",
}

export enum SubscriptionInterval {
  MONTHLY = "MONTHLY",
  ANNUALLY = "ANNUALLY",
}

export enum SubscriptionStatus {
  ACTIVE = "ACTIVE",
  CANCELLED = "CANCELLED",
  PAST_DUE = "PAST_DUE",
  EXPIRED = "EXPIRED",
}

// ============================================================
// ADD YOUR PROJECT-SPECIFIC ENUMS BELOW
// Follow the same PascalCase name + UPPER_SNAKE_CASE values pattern
// ============================================================
