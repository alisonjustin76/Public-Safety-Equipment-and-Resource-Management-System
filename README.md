# Public Safety Equipment and Resource Management System

A comprehensive smart contract system built on Stacks blockchain for managing public safety equipment and resources across multiple departments.

## Overview

This system provides transparent, immutable tracking of critical public safety equipment including police gear, fire department equipment, emergency medical supplies, training coordination, and replacement planning.

## Contracts

### 1. Police Equipment Inventory (`police-equipment.clar`)
- Tracks body cameras, weapons, and protective gear
- Manages equipment assignment to officers
- Monitors equipment status and maintenance schedules
- Handles equipment check-in/check-out processes

### 2. Fire Department Equipment (`fire-equipment.clar`)
- Manages fire trucks, hoses, and emergency response equipment
- Tracks equipment location and availability
- Monitors maintenance schedules and inspection dates
- Handles equipment deployment for emergencies

### 3. Emergency Medical Supplies (`ems-supplies.clar`)
- Monitors ambulance supplies and medical equipment
- Tracks inventory levels and expiration dates
- Manages supply distribution across stations
- Handles emergency restocking procedures

### 4. Public Safety Training Coordination (`training-coordination.clar`)
- Schedules mandatory training for first responders
- Tracks training completion and certifications
- Manages training resource allocation
- Monitors compliance with training requirements

### 5. Equipment Replacement Planning (`replacement-planning.clar`)
- Forecasts replacement needs based on equipment lifecycle
- Manages budget requirements for equipment replacement
- Tracks depreciation and usage patterns
- Plans procurement schedules

## Key Features

- **Transparency**: All equipment transactions recorded on blockchain
- **Accountability**: Immutable audit trail for equipment usage
- **Efficiency**: Automated tracking reduces manual paperwork
- **Compliance**: Ensures adherence to safety regulations
- **Budget Planning**: Data-driven replacement forecasting

## Data Types

### Equipment Status
- `available`: Equipment ready for use
- `in-use`: Currently deployed
- `maintenance`: Under repair or inspection
- `retired`: End of service life

### Priority Levels
- `critical`: Essential for emergency response
- `high`: Important for operations
- `medium`: Standard equipment
- `low`: Non-essential items

## Error Codes

- `ERR-NOT-AUTHORIZED (u100)`: Caller lacks required permissions
- `ERR-EQUIPMENT-NOT-FOUND (u101)`: Equipment ID does not exist
- `ERR-INVALID-STATUS (u102)`: Invalid equipment status
- `ERR-ALREADY-EXISTS (u103)`: Equipment already registered
- `ERR-INVALID-INPUT (u104)`: Invalid input parameters
- `ERR-INSUFFICIENT-SUPPLIES (u105)`: Not enough supplies available
- `ERR-EXPIRED-EQUIPMENT (u106)`: Equipment past expiration date
- `ERR-TRAINING-REQUIRED (u107)`: Training certification required
- `ERR-BUDGET-EXCEEDED (u108)`: Replacement budget exceeded

## Installation

1. Install Clarinet CLI
2. Clone this repository
3. Run `clarinet check` to validate contracts
4. Run `npm test` to execute test suite
5. Deploy using `clarinet deploy`

## Testing

The system includes comprehensive tests using Vitest:

\`\`\`bash
npm install
npm test
\`\`\`

## Usage Examples

### Adding Police Equipment
\`\`\`clarity
(contract-call? .police-equipment add-equipment
u1
"Body Camera"
"Axon Body 3"
"critical"
u1640995200)
\`\`\`

### Checking Out Fire Equipment
\`\`\`clarity
(contract-call? .fire-equipment checkout-equipment
u1
'SP1HTBVD3JG9C05J7HBJTHGR0GGW7KX17ECNP)
\`\`\`

### Updating Medical Supplies
\`\`\`clarity
(contract-call? .ems-supplies update-supply-level
u1
u50)
\`\`\`

## Security Considerations

- Only authorized personnel can modify equipment records
- All transactions are logged with timestamps
- Equipment assignments are tracked to specific officers/units
- Maintenance schedules are enforced through smart contract logic

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

MIT License - see LICENSE file for details
