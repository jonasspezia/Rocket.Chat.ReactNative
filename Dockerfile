# Etapa 1: Construção do projeto
FROM node:14-alpine AS builder

# Definir diretório de trabalho
WORKDIR /usr/src/app

# Copiar arquivos do package.json e yarn.lock
COPY package.json yarn.lock ./

# Instalar dependências
RUN yarn install

# Copiar o restante dos arquivos do projeto
COPY . .

# Construir o projeto Strapi para produção
RUN yarn build

# Remover as dependências de desenvolvimento
RUN yarn install --production --frozen-lockfile

# Etapa 2: Imagem final para produção
FROM node:14-alpine

# Definir diretório de trabalho
WORKDIR /usr/src/app

# Copiar os arquivos construídos da etapa anterior
COPY --from=builder /usr/src/app ./

# Expor a porta que o Strapi usará
EXPOSE 1337

# Definir variáveis de ambiente para produção
ENV NODE_ENV=production

# Iniciar o Strapi
CMD ["yarn", "start"]
