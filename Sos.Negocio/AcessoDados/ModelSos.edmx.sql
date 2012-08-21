
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, and Azure
-- --------------------------------------------------
-- Date Created: 08/01/2012 19:38:50
-- Generated from EDMX file: C:\Users\Erico\Documents\Visual Studio 2010\Projects\Sos\Sos.Negocio\AcessoDados\ModelSos.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [Sos];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_CategoriaProdutoProduto]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Produto] DROP CONSTRAINT [FK_CategoriaProdutoProduto];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[CategoriaProduto]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CategoriaProduto];
GO
IF OBJECT_ID(N'[dbo].[Produto]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Produto];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'CategoriasProduto'
CREATE TABLE [dbo].[CategoriasProduto] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Nome] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'Produtos'
CREATE TABLE [dbo].[Produtos] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Nome] nvarchar(max)  NOT NULL,
    [Descricao] nvarchar(max)  NULL,
    [Preco] decimal(18,0)  NULL,
    [PrecoAntigo] decimal(18,0)  NOT NULL,
    [Disponivel] bit  NOT NULL,
    [Imagem] nvarchar(max)  NOT NULL,
    [Categoria_Id] int  NOT NULL
);
GO

-- Creating table 'Usuario'
CREATE TABLE [dbo].[Usuario] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Email] nvarchar(max)  NOT NULL,
    [Senha] nvarchar(max)  NOT NULL,
    [EnderecoPrincipal_Id] int  NOT NULL
);
GO

-- Creating table 'Endereco'
CREATE TABLE [dbo].[Endereco] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Rua] nvarchar(max)  NOT NULL,
    [Numero] int  NOT NULL,
    [Complemento] nvarchar(max)  NULL,
    [Bairro] nvarchar(max)  NOT NULL,
    [Cidade] nvarchar(max)  NOT NULL,
    [Estado] nvarchar(max)  NOT NULL,
    [UsuarioEnderecos_Endereco_Id] int  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'CategoriasProduto'
ALTER TABLE [dbo].[CategoriasProduto]
ADD CONSTRAINT [PK_CategoriasProduto]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Produtos'
ALTER TABLE [dbo].[Produtos]
ADD CONSTRAINT [PK_Produtos]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Usuario'
ALTER TABLE [dbo].[Usuario]
ADD CONSTRAINT [PK_Usuario]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Endereco'
ALTER TABLE [dbo].[Endereco]
ADD CONSTRAINT [PK_Endereco]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [Categoria_Id] in table 'Produtos'
ALTER TABLE [dbo].[Produtos]
ADD CONSTRAINT [FK_CategoriaProdutoProduto]
    FOREIGN KEY ([Categoria_Id])
    REFERENCES [dbo].[CategoriasProduto]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_CategoriaProdutoProduto'
CREATE INDEX [IX_FK_CategoriaProdutoProduto]
ON [dbo].[Produtos]
    ([Categoria_Id]);
GO

-- Creating foreign key on [EnderecoPrincipal_Id] in table 'Usuario'
ALTER TABLE [dbo].[Usuario]
ADD CONSTRAINT [FK_UsuarioEndereco]
    FOREIGN KEY ([EnderecoPrincipal_Id])
    REFERENCES [dbo].[Endereco]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_UsuarioEndereco'
CREATE INDEX [IX_FK_UsuarioEndereco]
ON [dbo].[Usuario]
    ([EnderecoPrincipal_Id]);
GO

-- Creating foreign key on [UsuarioEnderecos_Endereco_Id] in table 'Endereco'
ALTER TABLE [dbo].[Endereco]
ADD CONSTRAINT [FK_UsuarioEnderecos]
    FOREIGN KEY ([UsuarioEnderecos_Endereco_Id])
    REFERENCES [dbo].[Usuario]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_UsuarioEnderecos'
CREATE INDEX [IX_FK_UsuarioEnderecos]
ON [dbo].[Endereco]
    ([UsuarioEnderecos_Endereco_Id]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------