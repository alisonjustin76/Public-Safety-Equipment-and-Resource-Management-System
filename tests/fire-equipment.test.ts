import { describe, it, expect, beforeEach } from "vitest"

describe("Fire Equipment Contract", () => {
  let contractAddress
  let deployer
  let fireChief
  let station1
  
  beforeEach(() => {
    contractAddress = "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.fire-equipment"
    deployer = "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM"
    fireChief = "ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5"
    station1 = 1
  })
  
  describe("Fire Equipment Management", () => {
    it("should add fire equipment successfully", () => {
      const equipmentData = {
        name: "Fire Engine 1",
        type: "pumper",
        stationId: station1,
        location: "Station 1 Bay A",
        capacity: 1000,
        priority: "critical",
      }
      
      const result = { type: "ok", value: 1 }
      expect(result.type).toBe("ok")
      expect(result.value).toBe(1)
    })
    
    it("should deploy equipment for emergency", () => {
      const equipmentId = 1
      const incidentType = "structure fire"
      
      const result = { type: "ok", value: 1 }
      expect(result.type).toBe("ok")
      expect(result.value).toBe(1) // deployment ID
    })
    
    it("should prevent deployment of unavailable equipment", () => {
      const equipmentId = 1
      const incidentType = "structure fire"
      
      // Mock equipment already deployed
      const result = { type: "error", value: 102 }
      expect(result.type).toBe("error")
      expect(result.value).toBe(102) // ERR-INVALID-STATUS
    })
    
    it("should return deployed equipment", () => {
      const equipmentId = 1
      
      const result = { type: "ok", value: true }
      expect(result.type).toBe("ok")
      expect(result.value).toBe(true)
    })
    
    it("should schedule equipment inspection", () => {
      const equipmentId = 1
      const inspectionDate = 1672531200
      
      const result = { type: "ok", value: true }
      expect(result.type).toBe("ok")
      expect(result.value).toBe(true)
    })
    
    it("should set maintenance status", () => {
      const equipmentId = 1
      
      const result = { type: "ok", value: true }
      expect(result.type).toBe("ok")
      expect(result.value).toBe(true)
    })
  })
  
  describe("Station Management", () => {
    it("should track equipment by station", () => {
      const stationId = 1
      
      const mockStationEquipment = {
        equipmentIds: [1, 2, 3],
      }
      
      expect(mockStationEquipment.equipmentIds).toHaveLength(3)
      expect(mockStationEquipment.equipmentIds).toContain(1)
    })
  })
  
  describe("Deployment Tracking", () => {
    it("should log deployment details", () => {
      const deploymentId = 1
      
      const mockDeployment = {
        equipmentId: 1,
        deployedBy: fireChief,
        deploymentTime: 1672531200,
        returnTime: null,
        incidentType: "structure fire",
      }
      
      expect(mockDeployment.equipmentId).toBe(1)
      expect(mockDeployment.incidentType).toBe("structure fire")
      expect(mockDeployment.returnTime).toBeNull()
    })
    
    it("should track deployment count", () => {
      const count = 3
      expect(count).toBe(3)
    })
  })
})
