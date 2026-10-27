# InsureIQ mobile (Flutter — Android & iOS)

See the [root README](../README.md) for setup and [the blueprint](../docs/01-technical-blueprint.md) for architecture.

```
lib/
  app/            app widget, router (go_router), theme tokens
  core/           config (--dart-define), network (dio + auth/refresh interceptor), secure token storage, shared widgets
  features/
    auth/         phone OTP login, profile setup
    home/         dashboard
    portfolio/    all policies with type filters
    policy/       add → processing → verify/manual/edit → detail (summary, renewal, claim help)
    assistant/    Ask AI chat with citations
    explore/      claim guides, coming-soon modules
    profile/      account, legal, logout, delete account
```
