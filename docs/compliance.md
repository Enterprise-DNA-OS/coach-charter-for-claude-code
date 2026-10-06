# Driver and vehicle record checks

Sources reviewed 6 October 2026. The command reports missing or expired evidence and a bounded set of recorded work-time exceptions. It does not authorise a departure, certify compliance, replace an approved logbook, or determine licence classes from a name.

## New Zealand

- NZ-COF: passenger service vehicles require a CoF. Store the actual expiry from evidence; no renewal interval is invented. [NZTA inspection classification](https://vehicleinspection.nzta.govt.nz/virms/in-service-wof-and-cof/introduction/inspection-and-certification-process/establishing-whether-the-vehicle-requires-a-wof-or).
- NZ-P: a large passenger service driver needs a passenger endorsement. Record the driver's licence and endorsement expiry. The operator must also verify licence class, restrictions, service licence and fitness separately. [NZTA large passenger service](https://www.nzta.govt.nz/business/transport-service-licences/large-passenger-service).
- NZ-5.5H: the standard work-time rule requires at least 30 minutes of rest after 5.5 hours of work. The check accumulates recorded work blocks until an explicit rest block of at least 30 minutes. An unrecorded gap is not assumed to be rest and is flagged. Other employment, administration and cleaning count as work. [NZTA work-time requirements](https://www.nzta.govt.nz/business/commercial-safety/work-time-and-logbook-requirements).
- NZ-13H: flags more than 780 minutes of work within the operator-supplied cumulative_day grouping. This is a declared cumulative work day, not a calendar-day inference. An incorrect grouping or missing work defeats the check. The same NZTA source requires a 10-hour continuous rest after a cumulative day and a 24-hour break after 70 cumulative work hours. Those multi-day limits, day boundaries, exceptions and alternative schemes require review of the complete logbook; this base does not calculate them.

## Australia

AU-INSPECTION and AU-AUTHORITY flag missing or expired recorded dates. These are evidence reminders, not national rules inferred from a state. Confirm the applicable state vehicle inspection, driver authority and operator accreditation requirements before dispatch.

AU-FATIGUE always asks for an Australian driver's fatigue scheme and complete work diary to be reviewed. NHVR distinguishes standard solo, bus and coach, two-up and accredited schemes. The base does not select a scheme or certify Australian hours. [NHVR bus industry](https://www.nhvr.gov.au/safety-accreditation-compliance/fatigue-management/heavy-vehicle-fatigue-management-bus-industry) and [work and rest hours](https://www.nhvr.gov.au/safety-accreditation-compliance/fatigue-management/work-and-rest-hours). Confirm territorial coverage and exemptions with the operator.

## Operational checks

Allocation refuses overlap, insufficient seats, inactive drivers, workshop vehicles, mismatched countries and missing or expired licence/inspection dates at journey end. Dates are compared in UTC, so verify the local service date at midnight boundaries. Matching countries is a conservative operating rule, not a statement of cross-border licensing law. ALLOCATED means the reservation exists, not that the journey is safe or legally cleared. Existing allocations can become stale when evidence changes; run dispatch and compliance again before issue.

Service due dates and a 60-minute turnaround review are configurable operating checks. They do not model route duration, depot dead running, refuelling, accessibility, meal breaks or actual fatigue. A dispatcher verifies those before releasing work tickets. The base records one vehicle and one driver per movement. Split multi-vehicle work into distinct movements; two-up and driver changes require a scoped extension.

A quiet compliance report proves only that these checks found no exception in these records. Missing history, operator accreditation, legal notices and employee records require separate review. Do not store licence scans or sensitive passenger details in Git.
