USE [master]
GO
CREATE DATABASE [ImageViewerDb]
GO
ALTER DATABASE [ImageViewerDb] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ImageViewerDb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ImageViewerDb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ImageViewerDb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ImageViewerDb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ImageViewerDb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ImageViewerDb] SET ARITHABORT OFF 
GO
ALTER DATABASE [ImageViewerDb] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ImageViewerDb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ImageViewerDb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ImageViewerDb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ImageViewerDb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ImageViewerDb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ImageViewerDb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ImageViewerDb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ImageViewerDb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ImageViewerDb] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ImageViewerDb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ImageViewerDb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ImageViewerDb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ImageViewerDb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ImageViewerDb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ImageViewerDb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ImageViewerDb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ImageViewerDb] SET RECOVERY FULL 
GO
ALTER DATABASE [ImageViewerDb] SET  MULTI_USER 
GO
ALTER DATABASE [ImageViewerDb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ImageViewerDb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ImageViewerDb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ImageViewerDb] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ImageViewerDb] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ImageViewerDb] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'ImageViewerDb', N'ON'
GO
ALTER DATABASE [ImageViewerDb] SET QUERY_STORE = OFF
GO
USE [ImageViewerDb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Images](
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](300) NULL,
	[UploadDate] [datetime] NOT NULL,
	[UploadedBy_id] [int] NOT NULL,
	[Path] [nvarchar](max) NOT NULL,
	[FileName] [nvarchar](max) NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Name] [varchar](50) NOT NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Images] ON 

INSERT [dbo].[Images] ([Name], [Description], [UploadDate], [UploadedBy_id], [Path], [FileName], [id]) VALUES (N'Dog', N'A dog is barking on the inside', CAST(N'2023-08-13T22:42:08.480' AS DateTime), 1, N'wwwroot/images/a6ef10a4-e90d-49d0-bfda-e11e8b46e5a6.webp', N'a6ef10a4-e90d-49d0-bfda-e11e8b46e5a6.webp', 19)
INSERT [dbo].[Images] ([Name], [Description], [UploadDate], [UploadedBy_id], [Path], [FileName], [id]) VALUES (N'Quentin Tarantino', N'Russian movie director', CAST(N'2023-08-13T22:55:17.740' AS DateTime), 1, N'wwwroot/images/40a52198-ab93-4f5f-847b-3a248d290a75.png', N'40a52198-ab93-4f5f-847b-3a248d290a75.png', 20)
INSERT [dbo].[Images] ([Name], [Description], [UploadDate], [UploadedBy_id], [Path], [FileName], [id]) VALUES (N'Eggs', N'Happy Easter!', CAST(N'2023-08-13T22:59:01.017' AS DateTime), 1, N'wwwroot/images/81f40e8b-a44c-4d40-9403-4eecd3f4c416.jpg', N'81f40e8b-a44c-4d40-9403-4eecd3f4c416.jpg', 21)
INSERT [dbo].[Images] ([Name], [Description], [UploadDate], [UploadedBy_id], [Path], [FileName], [id]) VALUES (N'Test 123', NULL, CAST(N'2023-08-15T20:07:33.160' AS DateTime), 1, N'wwwroot/images/59a56030-acdb-4c9a-a43c-a136059017a4.jpg', N'59a56030-acdb-4c9a-a43c-a136059017a4.jpg', 31)
SET IDENTITY_INSERT [dbo].[Images] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON

INSERT [dbo].[Users] ([Name], [id]) VALUES (N'System', 1)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
ALTER TABLE [dbo].[Images] ADD  DEFAULT (getdate()) FOR [UploadDate]
GO
ALTER TABLE [dbo].[Images] ADD  DEFAULT ('1') FOR [UploadedBy_id]
GO
USE [master]
GO
ALTER DATABASE [ImageViewerDb] SET  READ_WRITE 
GO
