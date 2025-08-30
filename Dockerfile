# >-----< BASE STAGE >-----< #

FROM postgres:17.6-alpine AS base

# >-----< TEST STAGE >-----< #

FROM base AS tester

RUN echo "[🔵]: No tests defined."

# >-----< RUN STAGE >-----< #

FROM base AS runner
