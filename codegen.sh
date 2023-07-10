#! zsh
source .env
# npm install -g get-graphql-schema
get-graphql-schema https://jysijxgffjwavdtqcuir.hasura.ap-south-1.nhost.run/v1/graphql -h "x-hasura-admin-secret=$HASURA_GRAPHQL_ADMIN_SECRET" > lib/schema.graphql
flutter pub run build_runner build --delete-conflicting-outputs
