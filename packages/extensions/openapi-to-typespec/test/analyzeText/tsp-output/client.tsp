import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";


using Azure.ClientGenerator.Core;
using Azure.Language.Authoring;









@@clientLocation(TextAnalysisAuthoringOperationGroup.listProjects, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.listProjects, "ListProjects")
@@clientLocation(TextAnalysisAuthoringOperationGroup.createProject, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.createProject, "CreateProject")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getProject, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.getProject, "GetProject")
@@clientLocation(TextAnalysisAuthoringOperationGroup.deleteProject, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.deleteProject, "DeleteProject")
@@clientLocation(TextAnalysisAuthoringOperationGroup.export, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.import, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.train, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.listDeployments, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.listDeployments, "ListDeployments")
@@clientLocation(TextAnalysisAuthoringOperationGroup.swapDeployments, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.swapDeployments, "SwapDeployments")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getDeployment, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.getDeployment, "GetDeployment")
@@clientLocation(TextAnalysisAuthoringOperationGroup.deployProject, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.deployProject, "DeployProject")
@@clientLocation(TextAnalysisAuthoringOperationGroup.deleteDeployment, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.deleteDeployment, "DeleteDeployment")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getDeploymentStatus, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.getDeploymentStatus, "GetDeploymentStatus")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getSwapDeploymentsStatus, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.getSwapDeploymentsStatus, "GetSwapDeploymentsStatus")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getExportStatus, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.getExportStatus, "GetExportStatus")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getImportStatus, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.getImportStatus, "GetImportStatus")
@@clientLocation(TextAnalysisAuthoringOperationGroup.listTrainedModels, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.listTrainedModels, "ListTrainedModels")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getTrainedModel, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.getTrainedModel, "GetTrainedModel")
@@clientLocation(TextAnalysisAuthoringOperationGroup.deleteTrainedModel, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.deleteTrainedModel, "DeleteTrainedModel")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getModelEvaluationResults, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.getModelEvaluationResults, "GetModelEvaluationResults")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getModelEvaluationSummary, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.getModelEvaluationSummary, "GetModelEvaluationSummary")
@@clientLocation(TextAnalysisAuthoringOperationGroup.listTrainingJobs, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.listTrainingJobs, "ListTrainingJobs")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getTrainingStatus, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.getTrainingStatus, "GetTrainingStatus")
@@clientLocation(TextAnalysisAuthoringOperationGroup.cancelTrainingJob, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.cancelTrainingJob, "CancelTrainingJob")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getProjectDeletionStatus, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.getProjectDeletionStatus, "GetProjectDeletionStatus")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getSupportedLanguages, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.getSupportedLanguages, "GetSupportedLanguages")
@@clientLocation(TextAnalysisAuthoringOperationGroup.listTrainingConfigVersions, "TextAnalysisAuthoring")
@@clientName(TextAnalysisAuthoringOperationGroup.listTrainingConfigVersions, "ListTrainingConfigVersions")


