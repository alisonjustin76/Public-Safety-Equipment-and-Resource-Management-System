;; Fire Department Equipment Contract
;; Manages fire trucks, hoses, and emergency response equipment

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-EQUIPMENT-NOT-FOUND (err u101))
(define-constant ERR-INVALID-STATUS (err u102))
(define-constant ERR-ALREADY-EXISTS (err u103))
(define-constant ERR-INVALID-INPUT (err u104))

;; Data Variables
(define-data-var equipment-counter uint u0)

;; Data Maps
(define-map fire-equipment-registry
  { equipment-id: uint }
  {
    name: (string-ascii 50),
    type: (string-ascii 30),
    station-id: uint,
    status: (string-ascii 15),
    location: (string-ascii 100),
    capacity: uint,
    last-inspection: uint,
    next-inspection: uint,
    deployment-count: uint,
    priority: (string-ascii 10)
  }
)

(define-map authorized-personnel principal bool)

(define-map station-equipment
  { station-id: uint }
  { equipment-ids: (list 50 uint) }
)

(define-map deployment-log
  { deployment-id: uint }
  {
    equipment-id: uint,
    deployed-by: principal,
    deployment-time: uint,
    return-time: (optional uint),
    incident-type: (string-ascii 50)
  }
)

(define-data-var deployment-counter uint u0)

;; Authorization Functions
(define-private (is-authorized (user principal))
  (or
    (is-eq user CONTRACT-OWNER)
    (default-to false (map-get? authorized-personnel user))
  )
)

(define-public (add-authorized-personnel (user principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (ok (map-set authorized-personnel user true))
  )
)

;; Equipment Management Functions
(define-public (add-fire-equipment
  (name (string-ascii 50))
  (type (string-ascii 30))
  (station-id uint)
  (location (string-ascii 100))
  (capacity uint)
  (priority (string-ascii 10)))
  (let
    (
      (equipment-id (+ (var-get equipment-counter) u1))
      (current-time block-height)
      (next-inspection (+ current-time u4320)) ;; ~30 days in blocks
      (current-station-equipment (default-to { equipment-ids: (list) } (map-get? station-equipment { station-id: station-id })))
    )
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (> (len name) u0) ERR-INVALID-INPUT)
    (asserts! (> station-id u0) ERR-INVALID-INPUT)

    (map-set fire-equipment-registry
      { equipment-id: equipment-id }
      {
        name: name,
        type: type,
        station-id: station-id,
        status: "available",
        location: location,
        capacity: capacity,
        last-inspection: current-time,
        next-inspection: next-inspection,
        deployment-count: u0,
        priority: priority
      }
    )

    (map-set station-equipment
      { station-id: station-id }
      { equipment-ids: (unwrap! (as-max-len? (append (get equipment-ids current-station-equipment) equipment-id) u50) ERR-INVALID-INPUT) }
    )

    (var-set equipment-counter equipment-id)
    (ok equipment-id)
  )
)

(define-public (deploy-equipment (equipment-id uint) (incident-type (string-ascii 50)))
  (let
    (
      (equipment (unwrap! (map-get? fire-equipment-registry { equipment-id: equipment-id }) ERR-EQUIPMENT-NOT-FOUND))
      (deployment-id (+ (var-get deployment-counter) u1))
      (current-time block-height)
    )
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (is-eq (get status equipment) "available") ERR-INVALID-STATUS)

    (map-set fire-equipment-registry
      { equipment-id: equipment-id }
      (merge equipment {
        status: "deployed",
        deployment-count: (+ (get deployment-count equipment) u1)
      })
    )

    (map-set deployment-log
      { deployment-id: deployment-id }
      {
        equipment-id: equipment-id,
        deployed-by: tx-sender,
        deployment-time: current-time,
        return-time: none,
        incident-type: incident-type
      }
    )

    (var-set deployment-counter deployment-id)
    (ok deployment-id)
  )
)

(define-public (return-equipment (equipment-id uint))
  (let
    (
      (equipment (unwrap! (map-get? fire-equipment-registry { equipment-id: equipment-id }) ERR-EQUIPMENT-NOT-FOUND))
      (current-time block-height)
    )
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (is-eq (get status equipment) "deployed") ERR-INVALID-STATUS)

    (map-set fire-equipment-registry
      { equipment-id: equipment-id }
      (merge equipment { status: "available" })
    )

    (ok true)
  )
)

(define-public (schedule-inspection (equipment-id uint) (inspection-date uint))
  (let
    (
      (equipment (unwrap! (map-get? fire-equipment-registry { equipment-id: equipment-id }) ERR-EQUIPMENT-NOT-FOUND))
      (next-inspection (+ inspection-date u4320)) ;; ~30 days from inspection
    )
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (> inspection-date (get last-inspection equipment)) ERR-INVALID-INPUT)

    (map-set fire-equipment-registry
      { equipment-id: equipment-id }
      (merge equipment {
        last-inspection: inspection-date,
        next-inspection: next-inspection,
        status: "available"
      })
    )
    (ok true)
  )
)

(define-public (set-maintenance-status (equipment-id uint))
  (let
    (
      (equipment (unwrap! (map-get? fire-equipment-registry { equipment-id: equipment-id }) ERR-EQUIPMENT-NOT-FOUND))
    )
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (is-eq (get status equipment) "available") ERR-INVALID-STATUS)

    (map-set fire-equipment-registry
      { equipment-id: equipment-id }
      (merge equipment { status: "maintenance" })
    )
    (ok true)
  )
)

;; Read-only Functions
(define-read-only (get-fire-equipment (equipment-id uint))
  (map-get? fire-equipment-registry { equipment-id: equipment-id })
)

(define-read-only (get-station-equipment (station-id uint))
  (map-get? station-equipment { station-id: station-id })
)

(define-read-only (get-deployment-log (deployment-id uint))
  (map-get? deployment-log { deployment-id: deployment-id })
)

(define-read-only (get-equipment-count)
  (var-get equipment-counter)
)

(define-read-only (get-deployment-count)
  (var-get deployment-counter)
)
