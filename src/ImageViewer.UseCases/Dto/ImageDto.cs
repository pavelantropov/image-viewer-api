﻿namespace ImageViewer.UseCases.Dto;

public class ImageDto
{
	public string Id { get; set; }
	public string Name { get; set; }
	public string Description { get; set; }
	public DateTime? UploadDate { get; set; }
	//public UserDto UploadedBy { get; set; }

	public byte[] Content { get; set; }
}