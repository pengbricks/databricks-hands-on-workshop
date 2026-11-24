# Setup

**Time:** 35 minutes, in two blocks (workspace, then Git folder and data).

## Steps

1. Sign in to your Free Edition workspace.
2. Find these in the sidebar: **Catalog**, **SQL Editor**, **Workspace**, **Jobs & Pipelines**, **Genie Agents**. Find **Databricks Apps** and **Lakebase Postgres** in the app switcher.
3. Click your user icon, then **Settings** > **Linked accounts** > **Add Git credential**. Choose **GitHub**, select **Link Git account**, click **Link**, then **Authorize Databricks** on the GitHub page. Install the Databricks GitHub app on your account when asked.
4. Go to **Workspace**, click **Create** > **Git folder**. Paste `https://github.com/pengbricks/databricks-hands-on-workshop.git`, keep GitHub as the provider, and click **Create Git folder**.
5. In the Git folder, open `setup/00_create_workshop_data` and click **Run all**.
6. Open `setup/01_first_queries` and run it.

## Done when

`01_first_queries` shows four admissions files in the volume and returns rows from them.

## If stuck

- Step 3 fails: skip it. This repository is public and clones without a linked account.
- A company GitHub account managed by your employer cannot install the app on personal repositories. Use a personal GitHub account.
- Step 4 fails: pair with a neighbor.

Docs: [Connect your Git provider](https://docs.databricks.com/aws/en/repos/get-access-tokens-from-git-provider), [Create and manage Git folders](https://docs.databricks.com/aws/en/repos/git-operations-with-repos)
