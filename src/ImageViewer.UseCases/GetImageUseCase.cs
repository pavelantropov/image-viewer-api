﻿using AutoMapper;
using ImageViewer.DataAccess.Repository;
using ImageViewer.Domain.Entities;
using ImageViewer.Infrastructure.Helpers;
using ImageViewer.UseCases.Dto;
using ImageViewer.UseCases.Interfaces;

namespace ImageViewer.UseCases;

public class GetImageUseCase : IGetImageUseCase
{
	private readonly IAsyncRepository _repository;
	private readonly IMapper _mapper;
	private readonly IFilesHelper _filesHelper;

	public GetImageUseCase(IAsyncRepository repository,
		IMapper mapper,
		IFilesHelper filesHelper)
	{
		_repository = repository;
		_mapper = mapper;
		_filesHelper = filesHelper;
	}

	public async Task<ImageDto?> Invoke(int id, CancellationToken cancellationToken = default)
	{
		var image = await _repository.GetAsync<Image>(id, cancellationToken);
		var imageDto = _mapper.Map<ImageDto>(image);

		imageDto.Content = await _filesHelper.ReadFileBytesAsync(image.Path, cancellationToken);

		return imageDto;
	}
}